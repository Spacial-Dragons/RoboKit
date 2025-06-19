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

import Foundation
import simd

extension FormManager {

    /// Updates the form rotation matrix based on Euler angles.
    ///
    /// This method synchronizes the `formRotationRelativeToRoot` property by converting
    /// the current Euler angles (roll, pitch, yaw) to a 3x3 rotation matrix.
    /// The conversion process involves:
    ///
    /// 1. Converting each Euler angle to radians
    /// 2. Creating individual quaternions for each rotation axis
    /// 3. Combining the quaternions in the order: roll * yaw * pitch
    /// 4. Converting the final quaternion to a rotation matrix
    ///
    /// This method is automatically called when `formEulerAngles` is modified
    /// due to the `didSet` property observer.
    ///
    /// The rotation order follows the standard aerospace sequence:
    /// - Roll: rotation around the X-axis
    /// - Yaw: rotation around the Y-axis  
    /// - Pitch: rotation around the Z-axis
    ///
    /// - Note: This method assumes Euler angles are stored in degrees and converts them to radians.
    /// - SeeAlso: `formEulerAngles` for the source Euler angle values.
    /// - SeeAlso: `formRotationRelativeToRoot` for the target rotation matrix.
    public func updateFormRotation() {
        let pitch = (formEulerAngles[.pitch] ?? 0).toRadians
        let yaw = (formEulerAngles[.yaw] ?? 0).toRadians
        let roll = (formEulerAngles[.roll] ?? 0).toRadians

        let pitchQuat = simd_quatf(angle: pitch, axis: SIMD3<Float>(1, 0, 0))
        let yawQuat = simd_quatf(angle: yaw, axis: SIMD3<Float>(0, 1, 0))
        let rollQuat = simd_quatf(angle: roll, axis: SIMD3<Float>(0, 0, 1))

        let finalQuat = rollQuat * yawQuat * pitchQuat
        formRotationRelativeToRoot = simd_float3x3(finalQuat)
    }
}
