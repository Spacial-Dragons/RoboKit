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

@Suite("InputSphereManager - Input Sphere Data Getters")
@MainActor
struct InputSpherePositionGetterTests {

    var manager = InputSphereManager()
    var root = Entity()
    var sphere = Entity()

    struct TestCase {
        let inputPosition: SIMD3<Float>
        let expectedROSPosition: SIMD3<Float>
        let description: Comment
    }

    let testCases: [TestCase] = [
        .init(inputPosition: [0, 0, 0], expectedROSPosition: [0, 0, 0], description: "Origin"),
        .init(inputPosition: [1, 2, 3], expectedROSPosition: [1, -3, 2], description: "Positive XYZ"),
        .init(inputPosition: [-1, -2, -3], expectedROSPosition: [-1, 3, -2], description: "Negative XYZ"),
        .init(inputPosition: [0, 1, 0], expectedROSPosition: [0, 0, 1], description: "Y axis only"),
        .init(inputPosition: [0, 0, 1], expectedROSPosition: [0, -1, 0], description: "Z axis only")
    ]

    @Test("Input Sphere position getter returns correct position relative to root in ROS coordinate system")
    func testGetPositionCases() {
        manager.inputSphere = sphere
        root.position = [0, 0, 0]

        for testCase in testCases {
            sphere.position = testCase.inputPosition
            let result = manager.getInputSpherePosition(relativeToRootPoint: root)

            #expect(result != nil, testCase.description)
            #expect(result == testCase.expectedROSPosition, "Failed for: \(testCase.description)")
        }
    }

    @Test("Input Sphere position getter returns nil position if inputSphere is nil")
    func testPositionNilWhenNoInputSphere() {
        manager.inputSphere = nil
        let result = manager.getInputSpherePosition(relativeToRootPoint: root)
        #expect(result == nil)
    }
}
