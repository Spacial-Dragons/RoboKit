//
//  Form Data Getters.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 23.05.2025.
//

import simd

extension FormManager {
    public func getFormPosition() -> SIMD3<Float> {
        let position = formPositionRelativeToRootROS
        return position
    }
    
    public func getFormRotation() -> simd_float3x3 {
        let rotation = formRotationRelativeToRoot.convertToROSCoordinateSystem()
        return rotation
    }
}

