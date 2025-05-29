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

extension InputSphereManager {

    public func rotateInputSphere() {
        guard let inputSphere else {
            AppLogger.shared.warning(
                "Attempted to rotate Input Sphere but sphere is nil",
                category: .inputsphere
            )
            return
        }

        let pitchQuat = simd_quatf(angle: inputSphereEulerAngles[.pitch] ?? 0, axis: [1, 0, 0])
        let yawQuat = simd_quatf(angle: (inputSphereEulerAngles[.yaw] ?? 0), axis: [0, 1, 0])
        let rollQuat = simd_quatf(angle: inputSphereEulerAngles[.roll] ?? 0, axis: [0, 0, 1])

        inputSphere.transform.rotation = rollQuat * yawQuat * pitchQuat
    }

    /// Updates the rotation of the Input Sphere based on its Euler angles.
    ///
    /// This method reads the current Euler angle values—roll, yaw, and pitch—from the
    /// `inputSphereEulerAngles` dictionary, converts them into quaternions, and
    /// combines them to update the `inputSphere`'s rotation.
    ///
    /// If the `inputSphere` is `nil`, this method performs no action.
    public func updateInputSphereRotation(relativeToRootPoint rootPoint: Entity) {
        guard let inputSphere else {
            AppLogger.shared.warning(
                "Attempted to update Input Sphere rotation but sphere is nil",
                category: .inputsphere
            )
            return
        }

        let transformMatrix = inputSphere.transformMatrix(relativeTo: rootPoint)
        inputSphereRotationRelativeToRoot = transformMatrix.rotationMatrix
    }
}
