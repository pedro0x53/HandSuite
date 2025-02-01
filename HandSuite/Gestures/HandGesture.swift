//
//  HandGesture.swift
//  HandTracker
//
//  Created by Pedro Sousa on 26/11/24.
//

import SwiftUI
import ARKit

public extension HandSuiteTools {
    @Observable
    class HandGesture: HandSuiteTools.GestureScheme {        
        public let chirality:  HandSuiteTools.Chirality
        public let direction: HandSuiteTools.Direction
        public let description: HandSuiteTools.GestureDescription

        public var recognitionEvents: HandSuiteTools.HandsEvents
        public var palmPoint: (simd_float4?, simd_float4?, HandSuiteTools.Direction?)
        public var palm: ([simd_quatf?]?, HandSuiteTools.Direction?)

        @MainActor
        public init(chirality: HandSuiteTools.Chirality = .either,
                    direction: HandSuiteTools.Direction = .any,
                    _ description: Set<HandSuiteTools.FingerDescription>,
                    jointComparisons: [HandSuiteTools.JointComparison] = []) {
            self.chirality = chirality
            self.direction = direction
            self.description = .hand(description, jointComparisons)
            self.recognitionEvents = .init()
        }
    }
}
