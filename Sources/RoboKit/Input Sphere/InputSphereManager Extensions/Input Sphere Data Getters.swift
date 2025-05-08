//
//  Input Sphere Data Getters.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import RealityKit
import SwiftUI

extension InputSphereManager {
    public func getInputSpherePosition(relativeToRootPoint rootPoint: Entity) -> SIMD3<Float>? {
        guard let inputSphere = inputSphere else { return nil }
        let transformMatrix = inputSphere.transformMatrix(relativeTo: rootPoint)
        let position = transformMatrix.position.convertToROSCoordinateSystem()
        return position
    }
    
    public func getInputSphereRotation(relativeToRootPoint rootPoint: Entity) -> simd_float3x3? {
        guard let inputSphere = inputSphere else { return nil }
        let transformMatrix = inputSphere.transformMatrix(relativeTo: rootPoint)
        let rotation = transformMatrix.rotationMatrix.convertToROSCoordinateSystem()
        return rotation
    }
}
