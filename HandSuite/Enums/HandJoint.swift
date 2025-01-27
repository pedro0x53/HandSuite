//
//  HandPoint.swift
//  HandSuite
//
//  Created by Narely Lima de Oliveira on 22/01/25.
//

import Foundation
import RealityKit

public extension HandSuiteTools {
    enum HandJoint: CaseIterable, Identifiable {
        case forearmArm
        case forearmWrist
        case indexFingerIntermediateBase
        case indexFingerIntermediateTip
        case indexFingerKnuckle
        case indexFingerMetacarpal
        case indexFingerTip
        case littleFingerIntermediateBase
        case littleFingerIntermediateTip
        case littleFingerKnuckle
        case littleFingerMetacarpal
        case littleFingerTip
        case middleFingerIntermediateBase
        case middleFingerIntermediateTip
        case middleFingerKnuckle
        case middleFingerMetacarpal
        case middleFingerTip
        case ringFingerIntermediateBase
        case ringFingerIntermediateTip
        case ringFingerKnuckle
        case ringFingerMetacarpal
        case ringFingerTip
        case thumbIntermediateBase
        case thumbIntermediateTip
        case thumbKnuckle
        case thumbTip
        case wrist
        
        public var id: String { description } // Identificador único para o Picker
        
        public var description: String {
            switch self {
            case .forearmArm: return "Forearm Arm"
            case .forearmWrist: return "Forearm Wrist"
            case .indexFingerIntermediateBase: return "Index Finger Intermediate Base"
            case .indexFingerIntermediateTip: return "Index Finger Intermediate Tip"
            case .indexFingerKnuckle: return "Index Finger Knuckle"
            case .indexFingerMetacarpal: return "Index Finger Metacarpal"
            case .indexFingerTip: return "Index Finger Tip"
            case .littleFingerIntermediateBase: return "Little Finger Intermediate Base"
            case .littleFingerIntermediateTip: return "Little Finger Intermediate Tip"
            case .littleFingerKnuckle: return "Little Finger Knuckle"
            case .littleFingerMetacarpal: return "Little Finger Metacarpal"
            case .littleFingerTip: return "Little Finger Tip"
            case .middleFingerIntermediateBase: return "Middle Finger Intermediate Base"
            case .middleFingerIntermediateTip: return "Middle Finger Intermediate Tip"
            case .middleFingerKnuckle: return "Middle Finger Knuckle"
            case .middleFingerMetacarpal: return "Middle Finger Metacarpal"
            case .middleFingerTip: return "Middle Finger Tip"
            case .ringFingerIntermediateBase: return "Ring Finger Intermediate Base"
            case .ringFingerIntermediateTip: return "Ring Finger Intermediate Tip"
            case .ringFingerKnuckle: return "Ring Finger Knuckle"
            case .ringFingerMetacarpal: return "Ring Finger Metacarpal"
            case .ringFingerTip: return "Ring Finger Tip"
            case .thumbIntermediateBase: return "Thumb Intermediate Base"
            case .thumbIntermediateTip: return "Thumb Intermediate Tip"
            case .thumbKnuckle: return "Thumb Knuckle"
            case .thumbTip: return "Thumb Tip"
            case .wrist: return "Wrist"
            }
        }
        
        public func toAnchoringTargetHandJoint() -> AnchoringComponent.Target.HandLocation.HandJoint {
            switch self {
            case .forearmArm: return .forearmArm
            case .forearmWrist: return .forearmWrist
            case .indexFingerIntermediateBase: return .indexFingerIntermediateBase
            case .indexFingerIntermediateTip: return .indexFingerIntermediateTip
            case .indexFingerKnuckle: return .indexFingerKnuckle
            case .indexFingerMetacarpal: return .indexFingerMetacarpal
            case .indexFingerTip: return .indexFingerTip
            case .littleFingerIntermediateBase: return .littleFingerIntermediateBase
            case .littleFingerIntermediateTip: return .littleFingerIntermediateTip
            case .littleFingerKnuckle: return .littleFingerKnuckle
            case .littleFingerMetacarpal: return .littleFingerMetacarpal
            case .littleFingerTip: return .littleFingerTip
            case .middleFingerIntermediateBase: return .middleFingerIntermediateBase
            case .middleFingerIntermediateTip: return .middleFingerIntermediateTip
            case .middleFingerKnuckle: return .middleFingerKnuckle
            case .middleFingerMetacarpal: return .middleFingerMetacarpal
            case .middleFingerTip: return .middleFingerTip
            case .ringFingerIntermediateBase: return .ringFingerIntermediateBase
            case .ringFingerIntermediateTip: return .ringFingerIntermediateTip
            case .ringFingerKnuckle: return .ringFingerKnuckle
            case .ringFingerMetacarpal: return .ringFingerMetacarpal
            case .ringFingerTip: return .ringFingerTip
            case .thumbIntermediateBase: return .thumbIntermediateBase
            case .thumbIntermediateTip: return .thumbIntermediateTip
            case .thumbKnuckle: return .thumbKnuckle
            case .thumbTip: return .thumbTip
            case .wrist: return .wrist
            }
        }
    }
}
