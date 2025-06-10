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
