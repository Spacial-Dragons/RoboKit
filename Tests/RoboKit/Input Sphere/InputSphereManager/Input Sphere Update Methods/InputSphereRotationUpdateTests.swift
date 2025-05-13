//
//  Input Sphere Rotation Update Tests.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 12.05.2025.
//
import RealityKit
import Testing
import simd
@testable import RoboKit

@Suite("InputSphereManager - Input Sphere Update Methods")
@MainActor
struct UpdateInputSphereRotationTests {

    var manager = InputSphereManager()
    var sphere = Entity()

    @Test("Input Sphere rotation updates correctly")
    func testUpdateRotationWithVariousEulerAngles() {
        let testCases: [(EulerAngles: [EulerAngle: Float], expectedRotation: simd_quatf)] = [
            (
                [.roll: .pi / 4, .yaw: .pi / 2, .pitch: .pi / 3],
                simd_quatf(angle: .pi / 4, axis: [0, 0, 1]) *
                simd_quatf(angle: .pi / 2, axis: [0, 1, 0]) *
                simd_quatf(angle: .pi / 3, axis: [1, 0, 0])
            ),
            (
                [.roll: .pi / 2, .yaw: .pi / 4, .pitch: .pi / 3],
                simd_quatf(angle: .pi / 2, axis: [0, 0, 1]) *
                simd_quatf(angle: .pi / 4, axis: [0, 1, 0]) *
                simd_quatf(angle: .pi / 3, axis: [1, 0, 0])
            )
        ]

        for (angles, expected) in testCases {
            manager.inputSphere = sphere
            sphere.transform.rotation = simd_quatf()
            manager.inputSphereEulerAngles = angles

            manager.updateInputSphereRotation()

            let dotProduct = simd_dot(sphere.transform.rotation, expected)
            #expect(abs(dotProduct - 1) < 0.0001)
        }
    }

    @Test("No rotation update if Input Sphere is nil")
    func testNoUpdateWhenInputSphereIsNil() {
        manager.inputSphere = nil
        let initialRotation = sphere.transform.rotation

        manager.updateInputSphereRotation()

        #expect(sphere.transform.rotation == initialRotation)
    }
}
