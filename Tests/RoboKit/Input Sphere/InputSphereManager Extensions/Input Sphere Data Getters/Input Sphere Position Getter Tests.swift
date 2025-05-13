//
//  Input Sphere Position Getter Tests.swift
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
struct InputSpherePositionGetterTests {

    var manager = InputSphereManager()
    var root = Entity()
    var sphere = Entity()

    @Test("Input Sphere position getter returns correct position relative to root in ROS coordinate system")
    func testGetPosition() {
        manager.inputSphere = sphere
        root.position = [0, 0, 0]
        sphere.position = [1, 2, 3]  // Will be converted to ROS: x, -z, y = [1, 3, -2]

        let result = manager.getInputSpherePosition(relativeToRootPoint: root)

        #expect(result != nil)
        #expect(result == SIMD3<Float>(1, -3, 2))  // ROS conversion
    }

    @Test("Input Sphere position getter returns nil position if inputSphere is nil")
    func testPositionNilWhenNoInputSphere() {
        manager.inputSphere = nil
        let result = manager.getInputSpherePosition(relativeToRootPoint: root)
        #expect(result == nil)
    }
}
