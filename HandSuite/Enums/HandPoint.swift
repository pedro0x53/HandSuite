//
//  HandPoint.swift
//  HandTracker
//
//  Created by Narely Lima de Oliveira on 24/01/25.
//

import Foundation
import RealityKit

public extension HandSuiteTools {
    enum HandPoint: CaseIterable, Identifiable {
        case aboveHand
        case palm
        case indexFingerTip
        case thumbTip
        case wrist
        
        public var id: String { description } // Identificador único para o Picker
        
        public var description: String {
            switch self {
            case .aboveHand: return "Above Hand"
            case .palm: return "Palm"
            case .indexFingerTip: return "Index Finger Tip"
            case .thumbTip: return "Thumb Tip"
            case .wrist: return "Wrist"
            }
        }
        
        // Conversão para o tipo esperado (adapte conforme necessário)
        public func toAnchoringTargetHandPoint() -> AnchoringComponent.Target.HandLocation{
            switch self {
            case .aboveHand: return .aboveHand
            case .palm: return .palm
            case .indexFingerTip: return .indexFingerTip
            case .thumbTip: return .thumbTip
            case .wrist: return .wrist
            }
        }
    }
}
