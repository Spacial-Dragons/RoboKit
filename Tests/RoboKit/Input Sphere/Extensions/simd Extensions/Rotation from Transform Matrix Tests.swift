//
//  Rotation from Transform Matrix Tests.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 12.05.2025.
//
import Testing
import simd
@testable import RoboKit

@Suite("simd Extensions")
struct RotationFromTransformMatrixTests {

    @Test("RotationMatrix getter extracts the correct 3x3 matrix")
    func testRotationMatrixGetter() {
        let transform = simd_float4x4(
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 0, 1)
        )

        let expected = simd_float3x3(
            SIMD3<Float>(1, 0, 0),
            SIMD3<Float>(0, 0, 1),
            SIMD3<Float>(0, 1, 0)
        )

        let result = transform.rotationMatrix
        #expect(result == expected)
    }

    @Test("RotationMatrix setter updates only the top-left 3x3 portion")
    func testRotationMatrixSetter() {
        var matrix = matrix_identity_float4x4

        let rotation = simd_float3x3(
            SIMD3<Float>(0, 1, 2),
            SIMD3<Float>(3, 4, 5),
            SIMD3<Float>(6, 7, 8)
        )

        matrix.rotationMatrix = rotation

        #expect(matrix.columns.0.x == 0)
        #expect(matrix.columns.0.y == 1)
        #expect(matrix.columns.0.z == 2)

        #expect(matrix.columns.1.x == 3)
        #expect(matrix.columns.1.y == 4)
        #expect(matrix.columns.1.z == 5)

        #expect(matrix.columns.2.x == 6)
        #expect(matrix.columns.2.y == 7)
        #expect(matrix.columns.2.z == 8)

        // Ensure other values remain untouched
        #expect(matrix.columns.0.w == 0)
        #expect(matrix.columns.1.w == 0)
        #expect(matrix.columns.2.w == 0)
        #expect(matrix.columns.3 == SIMD4<Float>(0, 0, 0, 1))
    }
}
