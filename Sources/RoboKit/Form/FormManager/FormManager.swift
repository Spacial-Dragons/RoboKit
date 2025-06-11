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

/// A manager class responsible for handling form data related to robot position and rotation.
///
/// The `FormManager` provides a centralized way to manage form inputs for robot control,
/// including position coordinates and rotation angles. It automatically handles coordinate
/// system conversions between RealityKit and ROS (Robot Operating System) coordinate systems.
///
/// This class is designed to work with SwiftUI's `@Observable` framework and is marked
/// as `@MainActor` to ensure thread safety for UI updates.
///
/// ## Usage
///
/// ```swift
/// @State private var formManager = FormManager()
///
/// // Update position in ROS coordinates
/// formManager.formPositionRelativeToRootROS = SIMD3<Float>(1.0, 2.0, 3.0)
///
/// // Update rotation using Euler angles
/// formManager.formEulerAngles[.roll] = Float.pi / 4
/// ```
@MainActor
@Observable
public final class FormManager {

    /// Initializes a new instance of the FormManager.
    ///
    /// Creates a FormManager with default values for position and rotation.
    /// The default position is set to (0, 0.3, 0) in RealityKit coordinates
    /// and (0, 0, 0.3) in ROS coordinates.
    public init() {}

    /// The position of the form relative to the root point in RealityKit coordinate system.
    ///
    /// This property represents the 3D position using RealityKit's coordinate system,
    /// where the Y-axis points upward. The position is stored as a `SIMD3<Float>`
    /// vector containing (x, y, z) coordinates.
    ///
    /// - Note: This property is automatically updated when `formPositionRelativeToRootROS` changes.
    /// - SeeAlso: `formPositionRelativeToRootROS` for the ROS coordinate system equivalent.
    public var formPositionRelativeToRoot: SIMD3<Float> = SIMD3<Float>(0, 0.3, 0)

    /// The position of the form relative to the root point in ROS coordinate system.
    ///
    /// This property represents the 3D position using ROS coordinate system,
    /// where the Z-axis points upward. The position is stored as a `SIMD3<Float>`
    /// vector containing (x, y, z) coordinates.
    ///
    /// When this property is modified, it automatically triggers `updateFormPosition()`
    /// to synchronize the RealityKit coordinate system position.
    ///
    /// - Note: ROS coordinate system differs from RealityKit: X (forward), Y (left), Z (up).
    /// - SeeAlso: `formPositionRelativeToRoot` for the RealityKit coordinate system equivalent.
    public var formPositionRelativeToRootROS: SIMD3<Float> = SIMD3<Float>(0, 0, 0.3) {
        didSet {
            self.updateFormPosition()
        }
    }

    /// The rotation matrix of the form relative to the root point in RealityKit coordinate system.
    ///
    /// This property represents the 3D rotation using a 3x3 rotation matrix in RealityKit's
    /// coordinate system. The matrix is initialized as an identity matrix, representing no rotation.
    ///
    /// - Note: This property is automatically updated when `formEulerAngles` changes.
    /// - SeeAlso: `formEulerAngles` for Euler angle representation.
    public var formRotationRelativeToRoot = simd_float3x3(
        SIMD3<Float>( 1, 0, 0),
        SIMD3<Float>( 0, 1, 0),
        SIMD3<Float>( 0, 0, 1)
    )

    /// The Euler angles representing the rotation of the form in degrees.
    ///
    /// This property stores rotation values for roll, pitch, and yaw angles.
    /// The angles are stored in radians and represent rotation around the X, Y, and Z axes respectively.
    ///
    /// When any angle is modified, it automatically triggers `updateFormRotation()`
    /// to synchronize the rotation matrix.
    ///
    /// - Note: Angles are stored in radians, not degrees.
    /// - SeeAlso: `formRotationRelativeToRoot` for matrix representation.
    public var formEulerAngles: [EulerAngle: Float] = [
        .roll: 0,
        .yaw: 0,
        .pitch: 0
    ] {
        didSet {
            self.updateFormRotation()
        }
    }

    /// A static rotation matrix used for converting between RealityKit and ROS coordinate systems.
    ///
    /// This matrix is used internally to transform rotation data between the two
    /// coordinate systems. The conversion accounts for the different axis orientations
    /// between RealityKit (Y-up) and ROS (Z-up) coordinate systems.
    ///
    /// The matrix performs the following transformation:
    /// - X-axis remains the same
    /// - Y-axis in RealityKit becomes Z-axis in ROS
    /// - Z-axis in RealityKit becomes Y-axis in ROS
    ///
    /// - Note: This is an internal property used for coordinate system conversions.
    internal static let rotationConversionMatrix = simd_float3x3(
        SIMD3<Float>( 1, 0, 0),
        SIMD3<Float>( 0, 0, 1),
        SIMD3<Float>( 0, 1, 0)
    )
}
