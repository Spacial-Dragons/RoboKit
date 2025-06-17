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

extension InputEntityManager {

    public func rotateInputEntity() {
        guard let inputEntity else {
            AppLogger.shared.warning(
                "Attempted to rotate Input Entity but entity is nil",
                category: .inputEntity
            )
            return
        }

        let pitchQuat = simd_quatf(angle: inputEntityEulerAngles[.pitch] ?? 0, axis: [1, 0, 0])
        let yawQuat = simd_quatf(angle: (inputEntityEulerAngles[.yaw] ?? 0), axis: [0, 0, 1])
        let rollQuat = simd_quatf(angle: inputEntityEulerAngles[.roll] ?? 0, axis: [0, 1, 0])

        inputEntity.transform.rotation = rollQuat * yawQuat * pitchQuat
    }

    /// Updates the rotation of the Input Entity based on its Euler angles.
    ///
    /// This method reads the current Euler angle values—roll, yaw, and pitch—from the
    /// `inputEntityEulerAngles` dictionary, converts them into quaternions, and
    /// combines them to update the `inputEntity`'s rotation.
    ///
    /// If the `inputEntity` is `nil`, this method performs no action.
    public func updateInputEntityRotation(relativeToRootPoint rootPoint: Entity) {
        guard let inputEntity else {
            AppLogger.shared.warning(
                "Attempted to update Input Entity rotation but entity is nil",
                category: .inputEntity
            )
            return
        }

        let transformMatrix = inputEntity.transformMatrix(relativeTo: rootPoint)
        inputEntityRotationRelativeToRoot = transformMatrix.rotationMatrix
    }
}
