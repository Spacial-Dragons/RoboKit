//
//  FormManager.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 20.05.2025.
//

import SwiftUI
import RealityKit

@MainActor
@Observable
public final class FormManager {

    public init() {}

    // Position in RealityKit coordinate system
    public var formPositionRelativeToRoot: SIMD3<Float> = SIMD3<Float>(0, 0.3, 0)

    // Position in ROS coordinate system
    public var formPositionRelativeToRootROS: SIMD3<Float> = SIMD3<Float>(0, 0, 0.3) {
        didSet {
            self.updateFormPosition()
        }
    }

    // Rotation in RealityKit coordinate system
    public var formRotationRelativeToRoot = simd_float3x3(
        SIMD3<Float>( 1, 0, 0),
        SIMD3<Float>( 0, 1, 0),
        SIMD3<Float>( 0, 0, 1)
    )

    public var formEulerAngles: [EulerAngle: Float] = [
        .roll: 0,
        .yaw: 0,
        .pitch: 0
    ] {
        didSet {
            self.updateFormRotation()
        }
    }

    // ROS conversion matrix
    internal static let rotationConversionMatrix = simd_float3x3(
        SIMD3<Float>( 1, 0, 0),
        SIMD3<Float>( 0, 0, 1),
        SIMD3<Float>( 0, 1, 0)
    )
}
