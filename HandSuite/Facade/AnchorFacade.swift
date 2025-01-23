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
    
    class AnchorFacade {
        @available(visionOS 2.0, *)
        @MainActor
        public static func createAnchor(for point: HandSuiteTools.HandPoint) -> AnchorEntity? {
            switch point {
            case .aboveHand:
                return createAnchorForAboveHand()
            case .indexFingerTip:
                return createAnchorForIndexFingerTip()
            case .palm:
                return createAnchorForPalmCenter()
            case .thumbTip:
                return createAnchorForThumbTip()
            case .wrist:
                return createAnchorForWrist()
            }
        }
        @available(visionOS 2.0, *)
        @MainActor
        private static func createAnchorForAboveHand() -> AnchorEntity {
            let anchor = AnchorEntity(.hand(.either, location: .aboveHand), trackingMode: .predicted)
            addMetallicBall(to: anchor)
            return anchor
        }
        @available(visionOS 2.0, *)
        @MainActor
        private static func createAnchorForIndexFingerTip() -> AnchorEntity {
            let anchor = AnchorEntity(.hand(.either, location: .indexFingerTip), trackingMode: .predicted)
            addMetallicBall(to: anchor)
            return anchor
        }
        @available(visionOS 2.0, *)
        @MainActor
        private static func createAnchorForPalmCenter() -> AnchorEntity {
            let anchor = AnchorEntity(.hand(.either, location: .palm), trackingMode: .predicted)
            addMetallicBall(to: anchor)
            return anchor
        }
        @available(visionOS 2.0, *)
        @MainActor
        private static func createAnchorForThumbTip() -> AnchorEntity {
            let anchor = AnchorEntity(.hand(.either, location: .thumbTip), trackingMode: .predicted)
            addMetallicBall(to: anchor)
            return anchor
        }
        @available(visionOS 2.0, *)
        @MainActor
        private static func createAnchorForWrist() -> AnchorEntity {
            let anchor = AnchorEntity(.hand(.either, location: .wrist), trackingMode: .predicted)
            addMetallicBall(to: anchor)
            return anchor
        }
        @available(visionOS 2.0, *)
        @MainActor
        public static func addMetallicBall(to anchor: AnchorEntity) {
            let sphere = MeshResource.generateSphere(radius: 0.005)
            let material = SimpleMaterial(color: .blue, isMetallic: false)
            let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
            
            sphereEntity.position = [0, 0, 0]
            anchor.addChild(sphereEntity)
        }
    }
}
