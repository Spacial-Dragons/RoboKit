//
//  Input Sphere Rotation Update.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import RealityKit

extension InputSphereManager {

    /// Updates the rotation of the Input Sphere based on its Euler angles.
    ///
    /// This method reads the current Euler angle values—roll, yaw, and pitch—from the
    /// `inputSphereEulerAngles` dictionary, converts them into quaternions, and
    /// combines them to update the `inputSphere`'s rotation.
    ///
    /// If the `inputSphere` is `nil`, this method performs no action.
    public func updateInputSphereRotation() {
        guard let inputSphere else {
            AppLogger.shared.warning(
                "Attempted to update Input Sphere rotation but sphere is nil",
                category: .inputsphere
            )
            return
        }
        let rollQuat = simd_quatf(angle: inputSphereEulerAngles[.roll] ?? 0, axis: [0, 0, 1])
        let yawQuat = simd_quatf(angle: (inputSphereEulerAngles[.yaw] ?? 0), axis: [0, 1, 0])
        let pitchQuat = simd_quatf(angle: inputSphereEulerAngles[.pitch] ?? 0, axis: [1, 0, 0])

        inputSphere.transform.rotation = rollQuat * yawQuat * pitchQuat

        let oldAngles = inputSphereEulerAngles
        
        // Log rotation changes if they are significant
        if oldAngles != inputSphereEulerAngles {
            // Log detailed rotation changes at debug level
            AppLogger.shared.debug(
                "Input Sphere rotation updated",
                category: .inputsphere,
                context: [
                    "roll": inputSphereEulerAngles[.roll]?.toDegrees ?? 0,
                    "yaw": inputSphereEulerAngles[.yaw]?.toDegrees ?? 0,
                    "pitch": inputSphereEulerAngles[.pitch]?.toDegrees ?? 0
                ]
            )
        }
    }
}
