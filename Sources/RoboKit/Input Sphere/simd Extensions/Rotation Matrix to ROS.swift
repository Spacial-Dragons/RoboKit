//
//  Rotation Matrix to ROS.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import simd

// Converts Rotation Matrix from RealityKit to ROS coordinate system
extension simd_float3x3 {
    @MainActor public func convertToROSCoordinateSystem() -> simd_float3x3 {
        let rotationConversionMatrix = InputSphereManager.rotationConversionMatrix
        return rotationConversionMatrix * self * rotationConversionMatrix.transpose
    }
}
