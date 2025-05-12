//
//  Input Sphere Rotation Update.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import RealityKit

extension InputSphereManager {

    /// Updates the rotation of the Input Sphere based on its Euler angles.
    public func updateInputSphereRotation() {
        guard let inputSphere else { return }

        let rollQuat = simd_quatf(angle: inputSphereEulerAngles[.roll] ?? 0, axis: [0, 0, 1])
        let yawQuat = simd_quatf(angle: (inputSphereEulerAngles[.yaw] ?? 0), axis: [0, 1, 0])
        let pitchQuat = simd_quatf(angle: inputSphereEulerAngles[.pitch] ?? 0, axis: [1, 0, 0])

        inputSphere.transform.rotation = rollQuat * yawQuat * pitchQuat
    }
}
