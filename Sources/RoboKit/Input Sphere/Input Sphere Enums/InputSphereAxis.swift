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


import RealityKit

/// An enumeration that defines the three principal axes of the Input Sphere,
/// oriented according to the ROS coordinate system.
///
/// Use `InputSphereAxis` to specify a spatial direction for the input sphere's reference components.
/// Each case provides its associated axis orientation and a distinct visual material for display in 3D space.
public enum InputSphereAxis {

    /// The longitudinal axis, aligned with the y-axis in the ROS coordinate system.
    /// This axis is commonly associated with roll. It includes a predefined orientation and green material.
    case longitudinal

    /// The vertical axis, aligned with the z-axis in the ROS coordinate system.
    /// This axis is commonly associated with yaw. No additional orientation is applied. The default material is blue.
    case vertical

    /// The lateral axis, aligned with the x-axis in the ROS coordinate system.
    /// This axis is commonly associated with pitch. It includes a predefined orientation and red material.
    case lateral

    /// The orientation quaternion for the axis, used to align visual representations in 3D space.
    ///
    /// - Note: Orientations are defined in the ROS coordinate system.
    /// The `vertical` axis does not require rotation and returns `nil`.
    public var orientation: simd_quatf? {
        switch self {
        case .lateral: return simd_quatf(angle: -.pi / 2, axis: [0, 0, 1])
        case .vertical: return nil
        case .longitudinal: return simd_quatf(angle: -.pi / 2, axis: [1, 0, 0])
        }
    }

    /// The material associated with the axis, used for visual distinction in the input sphere's appearance.
    ///
    /// - Returns: A `SimpleMaterial` with a unique color per axis—red for lateral, blue for vertical,
    /// and green for longitudinal.
    public var material: Material {
        switch self {
        case .lateral: return SimpleMaterial(color: .red, isMetallic: true)
        case .vertical: return SimpleMaterial(color: .blue, isMetallic: true)
        case .longitudinal: return SimpleMaterial(color: .green, isMetallic: true)
        }
    }
}
