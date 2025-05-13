//
//  Input Sphere Position String Tests.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 13.05.2025.
//
import RealityKit
import Testing
@testable import RoboKit

@Suite("InputSphereManager - Input Sphere Position String")
@MainActor
struct InputSpherePositionStringTests {

    var manager = InputSphereManager()
    let root = Entity()

    @Test("inputSpherePositionString() formats correctly for various positions")
    func testMultiplePositionCases() {
        let testCases: [(input: SIMD3<Float>, expected: String)] = [
            (SIMD3<Float>(1.0, 2.0, 3.0), " x: 1.000 m \t y: -3.000 m \t z: 2.000 m"),
            (SIMD3<Float>(0.0, 0.0, 0.0), " x: 0.000 m \t y: 0.000 m \t z: 0.000 m"),
            (SIMD3<Float>(-1.234, 5.678, -9.101), " x: -1.234 m \t y: 9.101 m \t z: 5.678 m"),
            (SIMD3<Float>(3.1415, 2.718, 1.618), " x: 3.141 m \t y: -1.618 m \t z: 2.718 m")
        ]

        for (input, expected) in testCases {
            manager.inputSpherePositionRelativeToRoot = input
            let result = manager.inputSpherePositionString(relativeToRootPoint: root)
            #expect(result == expected)
        }
    }

    @Test("inputSpherePositionString() returns nil when position is not set")
    func testPositionStringNil() {
        manager.inputSpherePositionRelativeToRoot = nil
        let result = manager.inputSpherePositionString(relativeToRootPoint: root)
        #expect(result == nil)
    }
}
