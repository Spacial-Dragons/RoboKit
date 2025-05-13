//
// ===----------------------------------------------------------------------=== //
//
// This source file is part of the RoboKit open source project
//
//
// Licensed under MIT
//
// See LICENSE for license information
// See "Contributors" section on GitHub for the list of project authors
//
// SPDX-License-Identifier: MIT
//
// ===----------------------------------------------------------------------=== //


import Testing
import Foundation
@testable import RoboKit

@Suite("Float Extensions")
struct FloatExtensionsTests {

    @Test("Degrees to radians converter")
    func testDegreesToRadiansConversion() {
        let testCases: [(degrees: Float, expectedRadians: Float)] = [
            (0, 0),
            (90, .pi / 2),
            (180, .pi),
            (-45, -.pi / 4),
            (360, 2 * .pi)
        ]

        for (degrees, expected) in testCases {
            let result = degrees.toRadians
            #expect(abs(result - expected) < 0.0001,
                    "\(degrees)° → Expected \(expected), got \(result)")
        }
    }

    @Test("Radians to degrees converter")
    func testRadiansToDegreesConversion() {
        let testCases: [(radians: Float, expectedDegrees: Float)] = [
            (0, 0),
            (.pi / 2, 90),
            (.pi, 180),
            (-.pi / 4, -45),
            (2 * .pi, 360)
        ]

        for (radians, expected) in testCases {
            let result = radians.toDegrees
            #expect(abs(result - expected) < 0.0001,
                    "\(radians) rad → Expected \(expected), got \(result)")
        }
    }
}
