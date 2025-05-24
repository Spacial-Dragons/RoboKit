//
//  Input Sphere Data Getters.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import RealityKit
import SwiftUI

extension InputSphereManager {
    
    public func getInputSpherePosition() -> SIMD3<Float>? {
        let position = inputSpherePositionRelativeToRoot?.convertToROSCoordinateSystem()
        return position
    }
    
    public func getInputSphereRotation() -> simd_float3x3? {
        let rotation = inputSphereRotationRelativeToRoot?.convertToROSCoordinateSystem()
        return rotation
    }
}
