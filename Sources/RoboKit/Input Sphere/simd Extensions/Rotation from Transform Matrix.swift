//
//  Rotation from Transform Matrix.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import simd

// Extension to extract a Rotation Matrix from the Transformation Matrix
extension simd_float4x4 {
    /// Returns a 3x3 matrix representing only the rotation (and scale).
    ///
    /// We’re taking the first three columns (x, y, z) of the 4x4 transform matrix
    /// because they encode orientation (rotation & scale).
    public var rotationMatrix: simd_float3x3 {
        get{
            simd_float3x3(
                simd_make_float3(self.columns.0),
                simd_make_float3(self.columns.1),
                simd_make_float3(self.columns.2)
            )
        } set {
            columns.0.x = newValue.columns.0.x
            columns.0.y = newValue.columns.0.y
            columns.0.z = newValue.columns.0.z
            columns.1.x = newValue.columns.1.x
            columns.1.y = newValue.columns.1.y
            columns.1.z = newValue.columns.1.z
            columns.2.x = newValue.columns.2.x
            columns.2.y = newValue.columns.2.y
            columns.2.z = newValue.columns.2.z
            
        }
    }
}
