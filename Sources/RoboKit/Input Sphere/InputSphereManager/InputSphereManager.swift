//
//  InputSphereManager.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 01.05.2025.
//

import SwiftUI
import RealityKit

@MainActor
@Observable public final class InputSphereManager {

    public init() {}

    /// The Input Sphere represents the target position and rotation for a robot's end effector.
    public var inputSphere: Entity?

    /// The current position of the Input Sphere relative to the Parent Entity.
    public var inputSpherePositionRelativeToParent: SIMD3<Float>?

    /// The current position of the Input Sphere relative to the Root Point.
    public var inputSpherePositionRelativeToRoot: SIMD3<Float>?

    /// The Euler angles (roll, yaw, pitch) of the Input Sphere.
    public var inputSphereEulerAngles: [EulerAngle: Float] = [
        .roll: 0,
        .yaw: 0,
        .pitch: 0
    ] {
        didSet {
            self.updateInputSphereRotation()
        }
    }

    /// RealityKit is using a 3D coordinate system common in many 3D engines:
    ///
    /// •⁠  ⁠Y-axis points upward
    /// •⁠  ⁠Z-axis points toward you
    /// •⁠  ⁠X-axis points to the right
    ///
    /// The rotation conversion matrix below is suited for converting RealityKit coordinate system to
    /// ROS coordinate system:
    /// •⁠  ⁠Y-axis points forward
    /// •⁠  ⁠Z-axis points upward
    /// •⁠  ⁠X-axis points to the right
    internal static let rotationConversionMatrix = simd_float3x3(
        SIMD3<Float>( 1, 0, 0),
        SIMD3<Float>( 0, 0, 1),
        SIMD3<Float>( 0, 1, 0)
    )

    /// Axis entities for the Input Sphere.
    public var inputSphereAxes: [InputSphereAxis: Entity] = [:]
}
