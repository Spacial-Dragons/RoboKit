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
