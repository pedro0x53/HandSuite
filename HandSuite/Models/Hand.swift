//
//  Hand.swift
//  HandTracker
//
//  Created by Pedro Sousa on 25/11/24.
//

import SwiftUI
import ARKit
import RealityKit
import simd

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

    func isPalmFacingUp() -> PalmDirection {
        guard let metacarpalMiddle = self.middleFinger?.getJoint(named: .knuckle) else { return .unknownDirection }
        let rotation = metacarpalMiddle.getCurrentRotation()

        if let axis = rotation?.axis, let angle = rotation?.angle {
            if (axis.x > 0 && axis.y < 0 && axis.z > 0 && angle > 2) {

            } else if (axis.x < 0 && axis.y < 0 && axis.z < 0 && angle > 1 && angle < 2) {
                Text("Palma pra baixo apontada pra frente")
                    .font(.system(size: 50))
                    .padding()

                return .palmDownFingersForward
            } else if (axis.x > 0 && axis.y < 0 && axis.z < 0 && angle > 1 && angle < 2) {
                Text("Mão apontando pra cima, palma pra frente")
                    .font(.system(size: 50))
                    .padding()
                return .palmForwardFingersUp
            } else if (axis.x < 0 && axis.y > 0 && axis.z < 0 && angle > 2) {
                Text("Mão apontando pra cima, palma pra trás")
                    .font(.system(size: 50))
                    .padding()
                return .palmBackwardFingersUp
            } else if (axis.x < 0 && axis.y < 0 && axis.z > 0 && angle > 1 && angle < 2) {
                Text("Palma pra cima dedos pra frente")
                    .font(.system(size: 50))
                    .padding()
                return .palmUpFingersForward
            } else {
                Text("Posição desconhecida")
                    .font(.system(size: 50))
                    .padding()
                return .unknownDirection
            }
        }

//        guard let metacarpalMiddle = self.middleFinger?.getJoint(named: .metacarpal),
//              let metacarpalLittle = self.littleFinger?.getJoint(named: .metacarpal),
//              let metacarpalIndex = self.indexFinger?.getJoint(named: .metacarpal),
//
//                let metacarpalMiddlePosition = metacarpalMiddle.getCurrentPosition(),
//              let metacarpalLittlePosition = metacarpalLittle.getCurrentPosition(),
//              let metacarpalIndexPosition = metacarpalIndex.getCurrentPosition() else { return nil }
//
//        // Calcula vetores do plano da palma
//        let vector1 = metacarpalLittlePosition - metacarpalMiddlePosition
//        let vector2 = metacarpalIndexPosition - metacarpalMiddlePosition
//
//        // Calcula o vetor normal ao plano da palma
//        let normalVector = simd_normalize(simd_cross(vector1, vector2))
//
//        // Compara o vetor normal com eixos globais para determinar orientação
//        let upVector = simd_float3(0, 1, 0)    // Eixo Y (para cima)
//        let forwardVector = simd_float3(0, 0, 1) // Eixo Z (para frente)
//        let rightVector = simd_float3(1, 0, 0) // Eixo X (para a direita)
//
//        // Pontuações para cada direção
//        let upDot = simd_dot(normalVector, upVector)
//        let forwardDot = simd_dot(normalVector, forwardVector)
//        let rightDot = simd_dot(normalVector, rightVector)
//
//        // Determina a orientação
//        if upDot > 0.7 {
//            print("Palma está para cima")
//        } else if upDot < -0.7 {
//            print("Palma está para baixo")
//        } else if forwardDot > 0.7 {
//            print("Palma está para frente")
//        } else if forwardDot < -0.7 {
//            print("Palma está para trás")
//        } else if rightDot > 0.7 {
//            print("Palma está para a direita")
//        } else if rightDot < -0.7 {
//            print("Palma está para a esquerda")
//        } else {
//            print("Palma está em uma posição intermediária")
//        }
//
//        return normalVector
    }
    func palm() -> SIMD3<Float>? {
        guard let metacarpalMiddle = self.middleFinger?.getJoint(named: .metacarpal),
              let knuckleMiddle = self.middleFinger?.getJoint(named: .knuckle),

              let metacarpalMiddlePosition = metacarpalMiddle.getCurrentPosition(),
              let knuckleMiddlePosition = knuckleMiddle.getCurrentPosition()
        else { return nil }

        // Calcula o ponto médio
        let middlePoint = SIMD3<Float>(
            (metacarpalMiddlePosition.x + knuckleMiddlePosition.x) / 2,
            (metacarpalMiddlePosition.y + knuckleMiddlePosition.y) / 2,
            (metacarpalMiddlePosition.z + knuckleMiddlePosition.z) / 2
        )

        // Calcula outro ponto ajustado
        let point = SIMD3<Float>(
            (metacarpalMiddlePosition.x + knuckleMiddlePosition.x) / 2,
            (metacarpalMiddlePosition.y + knuckleMiddlePosition.y) / 2 + 0.01,
            (metacarpalMiddlePosition.z + knuckleMiddlePosition.z) / 2
        )

        return (point - middlePoint)
    }

}

public enum PalmDirection {
    case palmForwardFingersUp
    case palmBackwardFingersUp
    case palmUpFingersForward
    case palmDownFingersForward
    case unknownDirection
}
