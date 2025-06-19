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
import Testing
import simd
@testable import RoboKit

@Suite("InputEntityManager - Input Entity Update Methods")
@MainActor
struct UpdateInputEntityRotationTests {

    var manager = InputEntityManager()
    var inputEntity = Entity()
    let root = Entity()

    @Test("Input Entity rotation updates correctly")
    func testUpdateRotationWithVariousEulerAngles() {
        let testCases: [(EulerAngles: [EulerAngle: Float], expectedRotation: simd_quatf)] = [
            (
                [.roll: .pi / 4, .yaw: .pi / 2, .pitch: .pi / 3],
                simd_quatf(angle: .pi / 4, axis: [0, 1, 0]) *
                simd_quatf(angle: .pi / 2, axis: [0, 0, 1]) *
                simd_quatf(angle: .pi / 3, axis: [1, 0, 0])
            ),
            (
                [.roll: .pi / 2, .yaw: .pi / 4, .pitch: .pi / 3],
                simd_quatf(angle: .pi / 2, axis: [0, 1, 0]) *
                simd_quatf(angle: .pi / 4, axis: [0, 0, 1]) *
                simd_quatf(angle: .pi / 3, axis: [1, 0, 0])
            )
        ]

        for (angles, expected) in testCases {
            manager.inputEntity = inputEntity
            inputEntity.transform.rotation = simd_quatf()
            manager.inputEntityEulerAngles = angles

            manager.rotateInputEntity()

            let dotProduct = simd_dot(inputEntity.transform.rotation, expected)
            #expect(abs(dotProduct - 1) < 0.0001)
        }
    }

    @Test("No rotation update if Input Entity is nil")
    func testNoUpdateWhenInputEntityIsNil() {
        manager.inputEntity = nil
        let initialRotation = inputEntity.transform.rotation

        manager.updateInputEntityRotation(relativeToRootPoint: root)

        #expect(inputEntity.transform.rotation == initialRotation)
    }
}
