//
//  Input Sphere Rotation Update.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import RealityKit

extension InputSphereManager {

    public func rotateInputSphere() {
        guard let inputSphere else { return }

        let pitchQuat = simd_quatf(angle: inputSphereEulerAngles[.pitch] ?? 0, axis: [1, 0, 0])
        let yawQuat = simd_quatf(angle: (inputSphereEulerAngles[.yaw] ?? 0), axis: [0, 1, 0])
        let rollQuat = simd_quatf(angle: inputSphereEulerAngles[.roll] ?? 0, axis: [0, 0, 1])

        inputSphere.transform.rotation = rollQuat * yawQuat * pitchQuat
    }
    
    public func updateInputSphereRotation(relativeToRootPoint rootPoint: Entity) {
        guard let inputSphere else { return }
        
        let transformMatrix = inputSphere.transformMatrix(relativeTo: rootPoint)
        inputSphereRotationRelativeToRoot = transformMatrix.rotationMatrix
    }
}
