//
//  SIMD Extensions.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 21.05.2025.
//

import simd

/// Converts Position Vector to an array
public extension SIMD3 where Scalar == Float {
    var array: [Float] {
        [x, y, z]
    }
}

//Position Vector to ROS
extension SIMD3 where Scalar == Float {
    /// Converts the current vector from RealityKit's to ROS (Robot Operating System) coordinate system.
    ///
    /// This method adjusts the vector's components to match the ROS coordinate convention,
    /// which uses a different axis orientation than RealityKit.
    ///
    /// Specifically:
    /// - The `x` component remains unchanged.
    /// - The `y` component becomes the negated original `z`, unless `z` is zero.
    /// - The `z` component becomes the original y.
    ///
    /// ```swift
    /// let original = SIMD3<Float>(1.0, 2.0, 3.0)
    /// let rosVector = original.convertToROSCoordinateSystem()
    /// // rosVector = SIMD3<Float>(1.0, -3.0, 2.0)
    /// ```
    ///
    /// - Returns: A `SIMD3<Float>` adjusted to match ROS coordinate system conventions.
    public func convertToROSCoordinateSystem() -> SIMD3<Float> {
        let newZ = z == 0 ? 0 : -z
        return SIMD3<Float>(x, newZ, y)
    }
}

// Rotation Matrix to ROS
extension simd_float3x3 {
    /// Converts a rotation matrix from RealityKit's to ROS (Robot Operating System) coordinate system.
    ///
    /// This method transforms the rotation matrix into a different coordinate system by pre- and post-multiplying
    /// it with a rotation conversion matrix and its transpose.
    ///
    /// The transformation is computed using the following formula:
    /// ```
    /// R_ros = M * R_realitykit * Mᵀ
    /// ```
    /// where:
    /// - `R_ros` is the resulting rotation matrix in ROS coordinates.
    /// - `R_realitykit` is the original rotation matrix in RealityKit coordinates.
    /// - `M` is the rotation conversion matrix.
    /// - `Mᵀ` is the transpose of the rotation conversion matrix.
    ///
    /// - Returns: A new `simd_float3x3` matrix representing the rotation in ROS coordinate system.
    @MainActor public func convertToROSCoordinateSystem() -> simd_float3x3 {
        let rotationConversionMatrix = InputSphereManager.rotationConversionMatrix
        return rotationConversionMatrix * self * rotationConversionMatrix.transpose
    }
}
