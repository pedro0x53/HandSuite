//
//  Hand.swift
//  HandTracker
//
//  Created by Pedro Sousa on 25/11/24.
//

import SwiftUI
import ARKit
import RealityKit

@Observable
public final class Hand: @unchecked Sendable {
    public let chirality: HandSuiteTools.Chirality
    @ObservationIgnored public private(set) var currentAnchor: HandAnchor?
    
    public private(set) var thumb: Hand.Finger?
    public private(set) var indexFinger: Hand.Finger?
    public private(set) var middleFinger: Hand.Finger?
    public private(set) var ringFinger: Hand.Finger?
    public private(set) var littleFinger: Hand.Finger?
    
    public private(set) var fingers: [Hand.Finger.Name: Finger] = [:]
    public private(set) var joints: [HandSkeleton.JointName: Hand.Joint] = [:]
    
    public init(chirality: HandSuiteTools.Chirality) {
        self.chirality = chirality
        self.setUp()
    }
    
    private func setUp() {
        self.thumb = Hand.Finger(name: .thumb, hand: self)
        self.fingers[.thumb] = thumb
        
        self.indexFinger = Hand.Finger(name: .index, hand: self)
        self.fingers[.index] = indexFinger
        
        self.middleFinger = Hand.Finger(name: .middle, hand: self)
        self.fingers[.middle] = middleFinger
        
        self.ringFinger = Hand.Finger(name: .ring, hand: self)
        self.fingers[.ring] = ringFinger
        
        self.littleFinger = Hand.Finger(name: .little, hand: self)
        self.fingers[.little] = littleFinger
        
        for (_, finger) in self.fingers {
            for (_, joint) in finger.joints {
                self.joints[joint.skeleton] = joint
            }
        }
    }
    
    // TODO: Create a HandSuite View with RealiView.update, .onAppear, and .task in order to create less boilerplate code in client code
    @MainActor
    func addToContet(_ content: RealityKit.RealityViewContent) {
        for (_, joint) in joints {
            joint.setModel(.createSphere())
            if let model = joint.model {
                content.add(model)
            }
        }
    }
    
    @MainActor
    func update(using anchor: HandAnchor) async {
        self.currentAnchor = anchor
        for (_, finger) in fingers {
            await finger.update(using: anchor)
        }
    }
    
    func getFinger(named name: Hand.Finger.Name) -> Finger {
        return self.fingers[name]!
    }
    
    func palm() -> (simd_float4?, simd_float4?, HandSuiteTools.Direction?) {
        guard let anchor = currentAnchor,
              let indexMetacarpalCurrentPosition = indexFinger?.getJoint(named: .metacarpal)?.getCurrentPosition(),
              let indexKnuckleCurrentPosition = indexFinger?.getJoint(named: .knuckle)?.getCurrentPosition() else {
            return (nil, nil, nil)
        }
        
        // Calcula o ponto médio
        let point = SIMD3<Float>(
            (indexMetacarpalCurrentPosition.x + indexKnuckleCurrentPosition.x) / 2,
            ((indexMetacarpalCurrentPosition.y + indexKnuckleCurrentPosition.y) / 2) + 0.01,
            (indexMetacarpalCurrentPosition.z + indexKnuckleCurrentPosition.z) / 2
        )

        
        let pointHomogeneous = SIMD4<Float>(point.x, point.y, point.z, 1.0)

        // Multiplicação da matriz pela coordenada homogênea
        let transformedPoint = anchor.originFromAnchorTransform * pointHomogeneous

        // Retornar a matriz de transformação que posiciona esse ponto na cena
        var transformMatrix = matrix_identity_float4x4
        transformMatrix.columns.3 = transformedPoint
        
        let translates = transformMatrix.columns.3
        
        var direction: HandSuiteTools.Direction?
        
        if translates.x > 0 && translates.y > 0 && translates.z > 0 {
            direction = .front
        } else if translates.x < 0 && translates.y > 0 && translates.z < -1 {
            direction = .back
        } else if translates.x < 0 && translates.y > 0 && translates.z > -1 && translates.z < -0.4 {
            direction = .up
        } else if translates.x > 0 && translates.y > 0 && translates.z < 0 {
            direction = .down
        }

        return (translates, anchor.originFromAnchorTransform.columns.3, direction)
    }
    
    func isPalmFacingUp() -> ([simd_quatf?], HandSuiteTools.Direction?) {
        guard let metacarpalMiddle = self.middleFinger?.getJoint(named: .knuckle),
              let knuckleMiddle = self.middleFinger?.getJoint(named: .knuckle) else { return ([], nil) }
        let rotationMetacarpalMiddle = metacarpalMiddle.getCurrentRotation()
        let rotationKnuckleMiddle = knuckleMiddle.getCurrentRotation()
        
        var direction: HandSuiteTools.Direction?
        
        if let axis = rotationKnuckleMiddle?.axis,
           let angle = rotationKnuckleMiddle?.angle {
            if (axis.x > 0 && axis.y < 0 && axis.z < 0 && angle > 1 && angle < 2) {
                direction = .front
            } else if (axis.x < 0 && axis.y < 0) {
                direction = .down
            } else if ((axis.x < 0 && axis.y > 0 && axis.z < 0) ||
                       (axis.x > 0 && (axis.y < -0.3 && axis.y > -0.9) && axis.z > 0)){
                direction = .back
            } else if ((axis.x > 0 && axis.y > 0 && axis.z > 0) ||
                (axis.x > 0 && axis.y < -0.09 && axis.z > 0)) {
                direction = .up
            } else {
                direction = nil
            }
        }
        
        return ([rotationMetacarpalMiddle, rotationKnuckleMiddle], direction)
    }

    
}
