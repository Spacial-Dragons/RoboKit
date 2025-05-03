//
//  Axis.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit

enum InputSphereAxis {
    case longitudinal, vertical, lateral
    
    var orientation: simd_quatf? {
        switch self {
        case .longitudinal: return simd_quatf(angle: -.pi / 2, axis: [0, 0, 1])
        case .vertical: return nil
        case .lateral: return simd_quatf(angle: .pi / 2, axis: [1, 0, 0])
        }
    }
    
    var material: Material {
        switch self {
        case .longitudinal: return SimpleMaterial(color: .green, isMetallic: true)
        case .vertical: return SimpleMaterial(color: .blue, isMetallic: true)
        case .lateral: return SimpleMaterial(color: .red, isMetallic: true)
        }
    }
}
