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

    @Test("Input Sphere rotation getter returns correct rotation matrix relative to root in ROS coordinate system")
    func testGetRotation() {
        manager.inputSphere = sphere

        // Set a known rotation: 90° around Z axis
        let angle: Float = .pi / 2
        let rotation = simd_quatf(angle: angle, axis: [0, 0, 1])
        sphere.transform.rotation = rotation

        let expectedRotation = sphere.transformMatrix(relativeTo: root).rotationMatrix.convertToROSCoordinateSystem()
        let result = manager.getInputSphereRotation(relativeToRootPoint: root)

        #expect(result != nil)
        #expect(result!.isApproximatelyEqual(to: expectedRotation, tolerance: 1e-4))
    }

    @Test("Input Sphere rotation getter returns nil rotation if inputSphere is nil")
    func testRotationNilWhenNoInputSphere() {
        manager.inputSphere = nil
        let result = manager.getInputSphereRotation(relativeToRootPoint: root)
        #expect(result == nil)
    }
}
