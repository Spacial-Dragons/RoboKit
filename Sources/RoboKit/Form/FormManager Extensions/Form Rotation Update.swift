//
//  FormRotationUpdate.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 23.05.2025.
//

import Foundation
import simd

extension FormManager {
    public func updateFormRotation() {
        let pitch = formEulerAngles[.pitch] ?? 0
        let yaw = formEulerAngles[.yaw] ?? 0
        let roll = formEulerAngles[.roll] ?? 0
        
        let pitchRotation = simd_float3x3(
            SIMD3<Float>(1, 0, 0),
            SIMD3<Float>(0, cos(pitch), -sin(pitch)),
            SIMD3<Float>(0, sin(pitch),  cos(pitch))
        )
        
        let yawRotation = simd_float3x3(
            SIMD3<Float>( cos(yaw), 0, sin(yaw)),
            SIMD3<Float>(0, 1, 0),
            SIMD3<Float>(-sin(yaw), 0, cos(yaw))
        )
        
        let rollRotation = simd_float3x3(
            SIMD3<Float>(cos(roll), -sin(roll), 0),
            SIMD3<Float>(sin(roll),  cos(roll), 0),
            SIMD3<Float>(0, 0, 1)
        )

        formRotationRelativeToRoot = rollRotation * yawRotation * pitchRotation
    }
}
