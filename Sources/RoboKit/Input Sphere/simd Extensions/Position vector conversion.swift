//
//  Position vector conversion.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

// Converts position from RealityKit to ROS coordinate system
extension SIMD3 where Scalar == Float {
    func convertToROSCoordinateSystem() -> SIMD3<Float> {
        let newZ = z == 0 ? 0 : -z
        return SIMD3<Float>(x, newZ, y)
    }
}
