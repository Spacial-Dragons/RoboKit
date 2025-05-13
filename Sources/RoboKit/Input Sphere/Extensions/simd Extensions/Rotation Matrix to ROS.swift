//
//  Rotation Matrix to ROS.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import simd

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
