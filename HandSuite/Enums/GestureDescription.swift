//
//  GestureDescription.swift
//  HandTracker
//
//  Created by Pedro Sousa on 27/11/24.
//

import Foundation

public extension HandSuiteTools {
    enum GestureDescription {
        case hand(Set<HandSuiteTools.FingerDescription>)
        case finger(HandSuiteTools.FingerDescription)
        case steps([HandSuiteTools.GestureStepDescription])
    }
}
