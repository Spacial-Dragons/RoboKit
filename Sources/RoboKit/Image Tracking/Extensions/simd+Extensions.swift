//
// ===----------------------------------------------------------------------=== //
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
// ===----------------------------------------------------------------------=== //

import simd

/// An extension to `simd_float4x4` providing convenient computed properties for position and orientation.
/// These properties facilitate easier access and modification of transformation components.
extension simd_float4x4 {

    /// The position component of the transformation matrix represented as a `SIMD3<Float>`.
    /// - Note: The position is stored in the fourth column of the matrix.
    var position: SIMD3<Float> {
        get {
            SIMD3<Float>(columns.3.x, columns.3.y, columns.3.z)
        }
        set {
            // Update the position while preserving the original w component.
            columns.3 = SIMD4<Float>(newValue.x, newValue.y, newValue.z, columns.3.w)
        }
    }

    /// The orientation component of the transformation matrix represented as a quaternion (`simd_quatf`).
    /// - Note: The orientation is derived from the upper-left 3x3 rotation matrix portion of the transform.
    var orientation: simd_quatf {
        get {
            // Extract a 3x3 rotation matrix from the first three columns of the 4x4 matrix.
            let rotationMatrix = simd_float3x3(
                SIMD3<Float>(columns.0.x, columns.0.y, columns.0.z),
                SIMD3<Float>(columns.1.x, columns.1.y, columns.1.z),
                SIMD3<Float>(columns.2.x, columns.2.y, columns.2.z)
            )
            return simd_quatf(rotationMatrix)
        }
        set {
            // Create a rotation matrix from the quaternion.
            let rotationMatrix = simd_float3x3(newValue)
            // Update the first three columns with the new rotation while preserving the original w components.
            columns.0 = SIMD4<Float>(rotationMatrix.columns.0, columns.0.w)
            columns.1 = SIMD4<Float>(rotationMatrix.columns.1, columns.1.w)
            columns.2 = SIMD4<Float>(rotationMatrix.columns.2, columns.2.w)
        }
    }
}
