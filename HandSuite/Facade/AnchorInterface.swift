//
//  AnchorFacade.swift
//
//  Created by Narely Lima de Oliveira on 21/01/25.
//

import RealityKit
import Vision
import Combine

public extension HandSuiteTools {
    
    class AnchorState: ObservableObject {
        @Published public var anchorEntity: AnchorEntity?
        public init() {}
    }
    class AnchorInterface {
        @available(visionOS 2.0, *)
        @MainActor
        public static func createAnchorPoint(chirality: AnchoringComponent.Target.Chirality, local: AnchoringComponent.Target.HandLocation, x: Float, y: Float, z: Float) -> AnchorEntity? {
            let anchor = AnchorEntity(.hand(chirality, location: local), trackingMode: .predicted)
            addMetallicBall(x: x, y: y, z: z, to: anchor)
            return anchor
        }
        @available(visionOS 2.0, *)
        @MainActor
        public static func createAnchorJoint(chirality: AnchoringComponent.Target.Chirality, local: AnchoringComponent.Target.HandLocation.HandJoint, x: Float, y: Float, z: Float) -> AnchorEntity? {
            let anchor = AnchorEntity(.hand(chirality, location: .joint(for: local)), trackingMode: .predicted)
            addMetallicBall(x: x, y: y, z: z, to: anchor)
            return anchor
        }
        @available(visionOS 2.0, *)
        @MainActor
        public static func addMetallicBall(x: Float, y: Float, z: Float, to anchor: AnchorEntity) {
            let sphere = MeshResource.generateSphere(radius: 0.005)
            let material = SimpleMaterial(color: .blue, isMetallic: false)
            let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
            
            sphereEntity.position = [x, y, z]
            anchor.addChild(sphereEntity)
        }
    }
}
