//
//  HandGesture.swift
//  HandTracker
//
//  Created by Pedro Sousa on 26/11/24.
//

import SwiftUI

public extension HandSuiteTools {
    @Observable
    class HandGesture: HandSuiteTools.GestureScheme {
        
        public var angle: Float?
        public var pointStart: SIMD3<Float>?
        public var pointEnd: SIMD3<Float>?

        public let chirality:  HandSuiteTools.Chirality
        public let direction: HandSuiteTools.Direction
        public let description: HandSuiteTools.GestureDescription

        public var recognitionEvents: HandSuiteTools.HandsEvents

        public var unitVector: SIMD3<Float>?
        public var palmPoint: SIMD3<Float>?

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
