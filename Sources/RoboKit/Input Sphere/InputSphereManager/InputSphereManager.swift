//
//  InputSphereManager.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 01.05.2025.
//

import SwiftUI
import RealityKit

/// A class responsible for managing the Input Sphere, which represents the desired position
/// and orientation of a robot's end effector in a 3D environment.
///
/// `InputSphereManager` provides properties and state for rendering, updating, and transforming
/// the Input Sphere within a RealityKit scene.
///
/// Use this class to track and update the position and rotation of the Input Sphere
/// relative to key reference points in the scene.
@MainActor
@Observable
public final class InputSphereManager {

    /// Creates a new instance of `InputSphereManager`.
    public init() {}

    /// The RealityKit entity representing the Input Sphere.
    ///
    /// This entity visually indicates the target pose (position and rotation) for a robot’s end effector.
    public var inputSphere: Entity?

    /// The current position of the Input Sphere relative to the parent entity in the scene.
    public var inputSpherePositionRelativeToParent: SIMD3<Float>?

    /// The current position of the Input Sphere relative to a designated root point.
    public var inputSpherePositionRelativeToRoot: SIMD3<Float>?

    /// A dictionary of Euler angles (roll, yaw, pitch) defining the Input Sphere’s rotation.
    ///
    /// Updating these values automatically applies a new rotation to the `inputSphere`.
    public var inputSphereEulerAngles: [EulerAngle: Float] = [
        .roll: 0,
        .yaw: 0,
        .pitch: 0
    ] {
        didSet {
            self.updateInputSphereRotation()
        }
    }

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

    /// A dictionary mapping each `InputSphereAxis` to its corresponding visual entity in the scene.
    public var inputSphereAxes: [InputSphereAxis: Entity] = [:]
}
