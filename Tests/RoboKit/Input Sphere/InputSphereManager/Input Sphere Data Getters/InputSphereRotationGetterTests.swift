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

import RealityKit
import simd
import Testing
@testable import RoboKit

@Suite("InputEntityManager - Input Entity Data Getters")
@MainActor
struct InputEntityRotationGetterTests {

    var manager = InputEntityManager()
    var root = Entity()
    var inputEntity = Entity()

    struct RotationTestCase {
        let description: Comment
        let rotation: simd_quatf
    }

    let testCases: [RotationTestCase] = [
        .init(description: "90° around longitudinal axis",
              rotation: simd_quatf(angle: .pi / 2, axis: [0, 0, 1])),
        .init(description: "180° around vertical axis",
              rotation: simd_quatf(angle: .pi, axis: [0, 1, 0])),
        .init(description: "45° around lateral axis",
              rotation: simd_quatf(angle: .pi / 4, axis: [1, 0, 0])),
        .init(description: "Identity rotation",
              rotation: simd_quatf())
    ]

    @Test("Input Entity rotation getter returns correct rotation matrix relative to root in ROS coordinate system")
    func testGetRotationCases() {
        manager.inputEntity = inputEntity

        for testCase in testCases {
            inputEntity.transform.rotation = testCase.rotation

            manager.updateInputEntityRotation(relativeToRootPoint: root)

            let expectedRotation = inputEntity.transformMatrix(relativeTo: root)
                .rotationMatrix.convertToROSCoordinateSystem()

            let result = manager.getInputEntityRotation()

            #expect(result != nil, testCase.description)
            #expect(result!.isApproximatelyEqual(to: expectedRotation, tolerance: 1e-4),
                    "Failed for: \(testCase.description)")

        }
    }

    @Test("Input Entity rotation getter returns nil rotation if inputEntity is nil")
    func testRotationNilWhenNoInputEntity() {
        manager.inputEntity = nil
        let result = manager.getInputEntityRotation()
        #expect(result == nil)
    }
}
