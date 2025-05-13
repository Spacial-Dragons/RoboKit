//
//  Input Sphere Position Update Tests.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 12.05.2025.
//

import Testing
import RealityKit
@testable import RoboKit

@Suite("InputSphereManager - Input Sphere Update Methods")
@MainActor
struct UpdateInputSpherePositionTests {

    var manager = InputSphereManager()
    var root = Entity()
    var sphere = Entity()

    @Test("Input Sphere position updates correctly")
    func testPositionUpdated() {
        sphere.position = [1, 2, 3]
        root.position = [0, 0, 1]

        manager.inputSphere = sphere
        manager.updateInputSpherePosition(rootPoint: root)

        #expect(manager.inputSpherePositionRelativeToParent == SIMD3<Float>(1, 2, 3))
        #expect(manager.inputSpherePositionRelativeToRoot == sphere.position(relativeTo: root))
    }
}
