//
//  Axis.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit

internal enum InputSphereAxis {
    case longitudinal, vertical, lateral
    
    // The orientation of Input Sphere axes is in ROS coordinate system
    var orientation: simd_quatf? {
        switch self {
        case .lateral: return simd_quatf(angle: -.pi / 2, axis: [0, 0, 1])
        case .vertical: return nil
        case .longitudinal: return simd_quatf(angle: -.pi / 2, axis: [1, 0, 0])
        }
    }
    
    var material: Material {
        switch self {
        case .lateral: return SimpleMaterial(color: .red, isMetallic: true)
        case .vertical: return SimpleMaterial(color: .blue, isMetallic: true)
        case .longitudinal: return SimpleMaterial(color: .green, isMetallic: true)
        }
    }
}
