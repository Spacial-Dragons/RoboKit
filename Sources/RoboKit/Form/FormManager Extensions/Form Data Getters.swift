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

extension FormManager {
    /// Retrieves the current form position in ROS coordinate system.
    ///
    /// This method returns the position of the form relative to the root point
    /// in ROS (Robot Operating System) coordinate system. The position is returned
    /// as a `SIMD3<Float>` vector containing (x, y, z) coordinates.
    ///
    /// - Returns: A `SIMD3<Float>` vector representing the position in ROS coordinates.
    /// - Note: This method returns the same value as `formPositionRelativeToRootROS`.
    /// - SeeAlso: `formPositionRelativeToRootROS` for the underlying property.
    public func getFormPosition() -> SIMD3<Float> {
        let position = formPositionRelativeToRootROS
        return position
    }

    /// Retrieves the current form rotation matrix converted to ROS coordinate system.
    ///
    /// This method returns the rotation matrix of the form relative to the root point,
    /// converted from RealityKit coordinate system to ROS coordinate system.
    /// The rotation is returned as a `simd_float3x3` matrix.
    ///
    /// The conversion accounts for the different axis orientations between
    /// RealityKit (Y-up) and ROS (Z-up) coordinate systems.
    ///
    /// - Returns: A `simd_float3x3` matrix representing the rotation in ROS coordinates.
    /// - Note: This method performs coordinate system conversion using `convertToROSCoordinateSystem()`.
    /// - SeeAlso: `formRotationRelativeToRoot` for the RealityKit coordinate system matrix.
    public func getFormRotation() -> simd_float3x3 {
        let rotation = formRotationRelativeToRoot.convertToROSCoordinateSystem()
        return rotation
    }
}
