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
import SwiftUI

extension InputSphereManager {

    /// Returns the position of the Input Sphere relative to the provided root point,
    /// transformed into the ROS coordinate system.
    ///
    /// This method retrieves the current position of the Input Sphere relative to the given `rootPoint` entity and
    /// converts it to match the ROS (Robot Operating System) coordinate conventions.
    ///
    /// - Returns: A `SIMD3<Float>` representing the position in ROS coordinates,
    /// or `nil` if the Input Sphere does not exist.
    public func getInputSpherePosition() -> SIMD3<Float>? {
        let position = inputSpherePositionRelativeToRoot?.convertToROSCoordinateSystem()

        if let position {
            // Log position retrieval at debug level
            AppLogger.shared.debug(
                "Input Sphere position retrieved",
                category: .inputsphere,
                context: [
                    "position": position,
                    "coordinateSystem": "ROS"
                ]
            )
        }

        return position
    }

    /// Returns the rotation matrix of the Input Sphere relative to the provided root point,
    /// transformed into the ROS coordinate system.
    ///
    /// This method retrieves the current orientation of the Input Sphere as a rotation matrix relative to the
    /// specified `rootPoint` entity and applies a conversion to match ROS coordinate conventions.
    ///
    /// - Returns: A `simd_float3x3` representing the rotation matrix in ROS coordinates,
    /// or `nil` if the Input Sphere does not exist.
    public func getInputSphereRotation() -> simd_float3x3? {
        let rotation = inputSphereRotationRelativeToRoot?.convertToROSCoordinateSystem()

        if let rotation {
            // Log rotation retrieval at debug level
            AppLogger.shared.debug(
                "Input Sphere rotation retrieved",
                category: .inputsphere,
                context: [
                    "rotationMatrix": [
                        "row0": [rotation[0][0], rotation[0][1], rotation[0][2]],
                        "row1": [rotation[1][0], rotation[1][1], rotation[1][2]],
                        "row2": [rotation[2][0], rotation[2][1], rotation[2][2]]
                    ],
                    "coordinateSystem": "ROS"
                ]
            )
        }

        return rotation
    }
}
