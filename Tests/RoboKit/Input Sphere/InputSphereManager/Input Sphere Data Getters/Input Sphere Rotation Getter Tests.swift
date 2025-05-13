//
//  Input Sphere Rotation Getter Tests.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 13.05.2025.
//

import RealityKit
import simd
import Testing
@testable import RoboKit

@Suite("InputSphereManager - Input Sphere Data Getters")
@MainActor
struct InputSphereRotationGetterTests {

    var manager = InputSphereManager()
    var root = Entity()
    var sphere = Entity()

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

    @Test("Input Sphere rotation getter returns correct rotation matrix relative to root in ROS coordinate system")
    func testGetRotationCases() {
        manager.inputSphere = sphere

        for testCase in testCases {
            sphere.transform.rotation = testCase.rotation

            let expectedRotation = sphere.transformMatrix(relativeTo: root)
                .rotationMatrix.convertToROSCoordinateSystem()

            let result = manager.getInputSphereRotation(relativeToRootPoint: root)

            #expect(result != nil, testCase.description)
            #expect(result!.isApproximatelyEqual(to: expectedRotation, tolerance: 1e-4),
                    "Failed for: \(testCase.description)")

        }
    }

    @Test("Input Sphere rotation getter returns nil rotation if inputSphere is nil")
    func testRotationNilWhenNoInputSphere() {
        manager.inputSphere = nil
        let result = manager.getInputSphereRotation(relativeToRootPoint: root)
        #expect(result == nil)
    }
}
