//
//  Rotation Matrix to ROS Tests.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 12.05.2025.
//
import Testing
import simd
@testable import RoboKit

@Suite("simd Extensions")
@MainActor
struct RotationMatrixToROSTests {

    @Test("Identity matrix remains unchanged after double conversion")
    func testDoubleConversionIsIdentity() {
        let identity = matrix_identity_float3x3
        let rosConverted = identity.convertToROSCoordinateSystem()
        let roundTripped = rosConverted.convertToROSCoordinateSystem()
        #expect(roundTripped.isApproximatelyEqual(to: identity))
    }

    @Test("Random matrix stays orthogonal after conversion")
    func testOrthogonalityPreserved() {
        let matrix = simd_float3x3(rows: [
            SIMD3<Float>(0, 1, 0),
            SIMD3<Float>(0, 0, 1),
            SIMD3<Float>(1, 0, 0)
        ])
        let rosMatrix = matrix.convertToROSCoordinateSystem()
        let shouldBeIdentity = rosMatrix.transpose * rosMatrix
        #expect(shouldBeIdentity.isApproximatelyEqual(to: matrix_identity_float3x3, tolerance: 1e-4))
    }
}

extension simd_float3x3 {
    func isApproximatelyEqual(to other: simd_float3x3, tolerance: Float = 1e-4) -> Bool {
        for row in 0..<3 {
            for column in 0..<3 where abs(self[row][column] - other[row][column]) > tolerance {
                return false
            }
        }
        return true
    }
}
