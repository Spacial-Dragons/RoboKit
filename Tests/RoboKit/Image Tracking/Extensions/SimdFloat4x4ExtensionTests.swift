//
//===----------------------------------------------------------------------===//
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
//===----------------------------------------------------------------------===//


import Testing
import simd
@testable import RoboKit

@Suite("simd_float4x4 Extension")
struct SimdFloat4x4ExtensionTests {

    // Transform matrix rotated 90 degrees along the Y-axis with coordinate position (1, 2, 3)
    let transformMatrix: simd_float4x4 = simd_float4x4(
        SIMD4<Float>(  0, 0, 1, 0),
        SIMD4<Float>(  0, 1, 0, 0),
        SIMD4<Float>( -1, 0, 0, 0),
        SIMD4<Float>(  1, 2, 3, 1)
    )

    /// simd_float4x4 transformation matrix layout:
    ///
    /// | m00 m01 m02 m03 |   // X  Y  Z  Perspective X
    /// | m10 m11 m12 m13 |   // X  Y  Z  Perspective Y
    /// | m20 m21 m22 m23 |   // X  Y  Z  Perspective Z
    /// | m30 m31 m32 m33 |   // Translation X, Y, Z, Homogeneous divisor
    ///
    /// Detailed Role:
    /// m00, m10, m20 — X-axis direction (rotation/scaling in X)
    /// m01, m11, m21 — Y-axis direction (rotation/scaling in Y)
    /// m02, m12, m22 — Z-axis direction (rotation/scaling in Z)
    /// m30, m31, m32 — Translation (position in world space)
    /// m03, m13, m23 — Perspective components (usually 0 in 3D)
    /// m33          — Homogeneous coordinate divisor (typically 1)
    ///
    /// For example, an identity matrix with no rotation, no scaling, and translation (1, 2, 3) would look like:
    ///
    /// | 1.0  0.0  0.0  0.0 |
    /// | 0.0  1.0  0.0  0.0 |
    /// | 0.0  0.0  1.0  0.0 |
    /// | 1.0  2.0  3.0  1.0 |

    @Test("Position getter")
    func positionGetterTest() {
        // Test that the position getter returns the correct vector from the fourth row.
        #expect(transformMatrix.position == SIMD3<Float>(1.0, 2.0, 3.0))
        #expect(transformMatrix.position.x == 1.0)
        #expect(transformMatrix.position.y == 2.0)
        #expect(transformMatrix.position.z == 3.0)
    }

    @Test("Position getter on identity matrix")
    func positionGetterIdentityTest() {
        let identity = matrix_identity_float4x4
        #expect(identity.position == SIMD3<Float>(0, 0, 0))
    }

    @Test("Position setter")
    func positionSetterTest() {
        // Verify that setting position updates the fourth column correctly without altering the component.
        var matrix = transformMatrix
        let newPosition = SIMD3<Float>(4, 5, 6)
        matrix.position = newPosition
        #expect(matrix.position == newPosition)
        #expect(matrix.position.x == 4.0)
        #expect(matrix.position.y == 5.0)
        #expect(matrix.position.z == 6.0)
    }

    @Test("Position setter on identity matrix")
    func positionSetterIdentityTest() {
        var identity = matrix_identity_float4x4
        identity.position = SIMD3<Float>(7, 8, 9)
        #expect(identity.position == SIMD3<Float>(7, 8, 9))
        #expect(identity.columns.3.w == 1.0)
    }

    @Test("Position setter preserves orientation")
    func positionSetterPreservesOrientationTest() {
        var matrix = transformMatrix
        let originalOrientation = matrix.orientation.normalized
        matrix.position = SIMD3<Float>(10, 11, 12)
        let newOrientation = matrix.orientation.normalized
        #expect(abs(newOrientation.angle - originalOrientation.angle) < 1e-6)
        #expect(abs(dot(newOrientation.axis, originalOrientation.axis)) > 0.9999)
    }

    @Test("Position setter doesn't affect other rows")
    func positionSetterDoesNotAffectOtherRowsTest() {
        var matrix = transformMatrix
        let originalCols = (matrix.columns.0, matrix.columns.1, matrix.columns.2)
        matrix.position = SIMD3<Float>(0, 0, 0)
        #expect(matrix.columns.0 == originalCols.0)
        #expect(matrix.columns.1 == originalCols.1)
        #expect(matrix.columns.2 == originalCols.2)
    }

    @Test("Orientation getter")
    func orientationGetterTest() {
        // Check that the orientation getter correctly extracts the rotation matrix and converts it into a quaternion.
        let orientation = transformMatrix.orientation.normalized
        let expected = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0)).normalized

        let angleDiff = abs(orientation.angle - expected.angle)
        let axisDot = dot(orientation.axis, expected.axis)

        #expect(angleDiff < 0.0001)
        #expect(abs(axisDot) > 0.9999)
    }

    @Test("Orientation setter 180° around X")
    func orientationSetter180XTest() {
        var matrix = transformMatrix
        let rotationQuat = simd_quatf(angle: .pi, axis: SIMD3<Float>(1, 0, 0))
        matrix.orientation = rotationQuat
        #expect(abs(matrix.columns.0.x - 1) < 1e-6)
        #expect(abs(matrix.columns.1.y + 1) < 1e-6)
        #expect(abs(matrix.columns.2.z + 1) < 1e-6)
    }

    @Test("Orientation setter 90° around Y")
    func orientationSetter90YTest() {
        var matrix = transformMatrix
        let rotationQuat = simd_quatf(angle: .pi/2, axis: SIMD3<Float>(0, 1, 0))
        matrix.orientation = rotationQuat
        #expect(abs(matrix.columns.0.z + 1) < 1e-6)
        #expect(abs(matrix.columns.2.x - 1) < 1e-6)
    }

    @Test("Orientation setter 90° around Z")
    func orientationSetter90ZTest() {
        var matrix = transformMatrix
        let rotationQuat = simd_quatf(angle: .pi/2, axis: SIMD3<Float>(0, 0, 1))
        matrix.orientation = rotationQuat
        #expect(abs(matrix.columns.0.y - 1) < 1e-6)
        #expect(abs(matrix.columns.1.x + 1) < 1e-6)
    }

    @Test("Orientation setter preserves translation")
    func orientationSetterPreservesTranslationTest() {
        var matrix = transformMatrix
        let rotationQuat = simd_quatf(angle: .pi/3, axis: SIMD3<Float>(0, 1, 0))
        matrix.orientation = rotationQuat
        #expect(matrix.columns.3 == transformMatrix.columns.3)
    }

}
