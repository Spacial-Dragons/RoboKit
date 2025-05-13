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
import RealityKit
import simd
@testable import RoboKit

@Suite("InputSphereAxis")
struct InputSphereAxisTests {

    @Test("Orientation values match expected quaternions")
    func testOrientationValues() {
        let tolerance: Float = 1e-5

        // Lateral: rotation -π/2 around Z
        if let lateralOrientation = InputSphereAxis.lateral.orientation {
            let expected = simd_quatf(angle: -.pi / 2, axis: [0, 0, 1])
            #expect(abs(lateralOrientation.angle - expected.angle) < tolerance)
            #expect(dot(lateralOrientation.axis, expected.axis) > 0.9999)
        } else {
            #expect(Bool(false), "Lateral orientation should not be nil")
        }

        // Vertical: nil
        #expect(InputSphereAxis.vertical.orientation == nil)

        // Longitudinal: rotation -π/2 around X
        if let longitudinalOrientation = InputSphereAxis.longitudinal.orientation {
            let expected = simd_quatf(angle: -.pi / 2, axis: [1, 0, 0])
            #expect(abs(longitudinalOrientation.angle - expected.angle) < tolerance)
            #expect(dot(longitudinalOrientation.axis, expected.axis) > 0.9999)
        } else {
            #expect(Bool(false), "Longitudinal orientation should not be nil")
        }
    }
}
