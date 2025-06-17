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

import SwiftUI
import RealityKit

/// A class responsible for managing the Input Entity, which represents the desired position
/// and orientation of a robot's end effector in a 3D environment.
///
/// `InputEntityManager` provides properties and state for rendering, updating, and transforming
/// the Input Entity within a RealityKit scene.
///
/// Use this class to track and update the position and rotation of the Input Entity
/// relative to key reference points in the scene.
@MainActor
@Observable
public final class InputEntityManager {

    /// Creates a new instance of `InputEntityManager`.
    public init() {}

    /// The RealityKit entity representing the Input Entity.
    ///
    /// This entity visually indicates the target pose (position and rotation) for a robot’s end effector.
    public var inputEntity: Entity?

    /// The current position of the Input Entity relative to the parent entity in the scene.
    public var inputEntityPositionRelativeToParent: SIMD3<Float>?

    /// The current position of the Input Entity relative to a designated root point.
    public var inputEntityPositionRelativeToRoot: SIMD3<Float>?

    public var inputEntityRotationRelativeToRoot: simd_float3x3?

    /// A dictionary of Euler angles (roll, yaw, pitch) defining the Input Entity's rotation.
    ///
    /// Updating these values automatically applies a new rotation to the `inputEntity`.
    public var inputEntityEulerAngles: [EulerAngle: Float] = [
        .roll: 0,
        .yaw: 0,
        .pitch: 0
    ]

    /// A matrix used to convert rotations between RealityKit’s and ROS’s coordinate systems.
    ///
    /// ### Coordinate System Comparison
    /// **RealityKit:**
    /// - Y-axis points upward
    /// - Z-axis points toward the viewer
    /// - X-axis points to the right
    ///
    /// **ROS:**
    /// - Y-axis points forward
    /// - Z-axis points upward
    /// - X-axis points to the right
    ///
    /// This rotation matrix facilitates transformations between these systems.
    internal static let rotationConversionMatrix = simd_float3x3(
        SIMD3<Float>( 1, 0, 0),
        SIMD3<Float>( 0, 0, 1),
        SIMD3<Float>( 0, 1, 0)
    )

    /// A dictionary mapping each `InputEntityAxis` to its corresponding visual entity in the scene.
    public var inputEntityAxes: [InputEntityAxis: Entity] = [:]
}
