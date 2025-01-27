//
//  Chirality.swift
//  HandTracker
//
//  Created by Pedro Sousa on 27/11/24.
//

import Foundation
import RealityKit

public extension HandSuiteTools {
    enum Chirality: Int, CaseIterable, Identifiable {
        case either
        case left
        case right
        public var id: Int { rawValue }
        
        public var description: String {
            switch self {
            case .either: return "Either"
            case .left: return "Left"
            case .right: return "Right"
            }
        }
        public func toAnchoringTargetChirality() -> AnchoringComponent.Target.Chirality {
            switch self {
            case .either:
                return .either
            case .left:
                return .left
            case .right:
                return .right
            }
        }
    }
}
