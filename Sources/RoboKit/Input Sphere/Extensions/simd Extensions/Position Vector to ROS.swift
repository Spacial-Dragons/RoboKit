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
