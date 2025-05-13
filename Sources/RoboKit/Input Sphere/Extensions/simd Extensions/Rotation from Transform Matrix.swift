//
//  Rotation from Transform Matrix.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import simd

extension simd_float4x4 {
    /// A 3×3 rotation matrix extracted from or inserted into the upper-left portion of the transformation matrix.
    ///
    /// This property allows you to extract or set the rotation component of a 4×4 transformation matrix.
    /// The rotation matrix is derived from the upper-left 3×3 submatrix, which typically represents
    /// the orientation of an object in 3D space.
    ///
    /// When setting this property, the existing 3×3 rotation portion of the matrix is updated,
    /// leaving the translation and perspective components unchanged.
    ///
    /// Example:
    /// ```swift
    /// let transform = simd_float4x4(...)
    /// let rotation = transform.rotationMatrix
    ///
    /// var newTransform = transform
    /// newTransform.rotationMatrix = simd_float3x3(...)
    /// ```
    ///
    /// - Note: The setter modifies only the rotation portion (`columns.0`, `columns.1`, and `columns.2`) of the matrix.
    public var rotationMatrix: simd_float3x3 {
        get {
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
