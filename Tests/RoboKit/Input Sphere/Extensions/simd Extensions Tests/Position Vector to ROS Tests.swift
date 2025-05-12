//
//  Position Vector to ROS Tests.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 12.05.2025.
//
import Testing
import simd
@testable import RoboKit

@Suite("simd Extensions")
struct PositionConverterTests {

    @Test("Position converter from RealityKit to ROS coordinate system")
    func testPositionConvertionToROSCoordinateSystem() {
        let testCases: [(input: SIMD3<Float>, expected: SIMD3<Float>)] = [
            (SIMD3<Float>(1, 2, 3), SIMD3<Float>(1, -3, 2)),
            (SIMD3<Float>(-4, -5, -6), SIMD3<Float>(-4, 6, -5)),
            (SIMD3<Float>(7, 8, 0), SIMD3<Float>(7, 0, 8)),
            (SIMD3<Float>(9.5, -3.2, 1.1), SIMD3<Float>(9.5, -1.1, -3.2))
        ]

        for (input, expected) in testCases {
            let result = input.convertToROSCoordinateSystem()
            #expect(abs(result.x - expected.x) < 0.0001)
            #expect(abs(result.y - expected.y) < 0.0001)
            #expect(abs(result.z - expected.z) < 0.0001)
        }
    }
}
