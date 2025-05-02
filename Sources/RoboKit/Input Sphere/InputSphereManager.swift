//
//  InputSphereManager.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 01.05.2025.
//

import SwiftUI
import RealityKit

@MainActor
@Observable public final class InputSphereManager: Sendable {
    /// The Input Sphere represents the target position and rotation for a robot's end effector.
    public var inputSphere: Entity? = nil
    
    /// The name of the Input Sphere entity.
    let inputSphereName = "InputSphere"
    
    /// The current position of the Input Sphere.
    var inputSpherePosition: SIMD3<Float> = .zero
    
    /// The Euler angles (roll, yaw, pitch) of the Input Sphere.
    var inputSphereEulerAngles: [EulerAngle: Float] = [
        .roll: 0,
        .yaw: 0,
        .pitch: 0
    ]
    
    /// Axis entities for the Input Sphere.
    var inputSphereAxes: [Axis: Entity] = [:]
    
//    /// The height of the Input Sphere’s axis.
//    let inputSphereAxisHeight: Float = 0.1
//    
//    /// The radius of the Input Sphere’s axis.
//    let inputSphereAxisRadius: Float = 0.002
}
