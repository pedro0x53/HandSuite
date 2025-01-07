//
//  GestureScheme.swift
//  HandTracker
//
//  Created by Pedro Sousa on 27/11/24.
//

import ARKit

public extension HandSuiteTools {
    protocol GestureScheme: AnyObject {
        var chirality: HandSuiteTools.Chirality { get }
        var direction: HandSuiteTools.Direction { get }
        var description: HandSuiteTools.GestureDescription { get }

        var wasRecognized: Bool { get }

        var recognitionEvents: HandSuiteTools.HandsEvents { get set }

        var leftEvent: HandSuiteTools.HandEvent? { get }
        var rightEvent: HandSuiteTools.HandEvent? { get }
        
        func recognize(in hand: Hand) async
    }
}

public extension HandSuiteTools.GestureScheme {
    var leftEvent: HandSuiteTools.HandEvent? { recognitionEvents.leftHand }
    var rightEvent: HandSuiteTools.HandEvent? { recognitionEvents.rightHand }

    var wasRecognized: Bool {
        switch self.chirality {
        case .either:
            return (leftEvent?.wasRecognized ?? false) || (rightEvent?.wasRecognized ?? false)
        case .left:
            return leftEvent?.wasRecognized ?? false
        case .right:
            return rightEvent?.wasRecognized ?? false
        }
    }

    func recognize(in hand: Hand) {
        guard case .hand(let fingers) = description else { return }

        let wasRecognized = fingers.allSatisfy { fingerDescription in
            let finger = hand.getFinger(named: fingerDescription.name)

            let curlnessAccepted = fingerDescription.state == .straight ? true : finger.curlness >=  fingerDescription.curlness
            let stateAccepted = fingerDescription.state == .neutral ? true : finger.state == fingerDescription.state
            let directionAccepted = fingerDescription.direction == .any ? true : finger.direction == fingerDescription.direction

            return curlnessAccepted && stateAccepted && directionAccepted
        }

        let event = HandSuiteTools.HandEvent(wasRecognized: wasRecognized, hand: hand)

        if hand.chirality == .left {
            self.recognitionEvents.leftHand = event
        }

        if hand.chirality == .right {
            self.recognitionEvents.rightHand = event
        }
    }
}
