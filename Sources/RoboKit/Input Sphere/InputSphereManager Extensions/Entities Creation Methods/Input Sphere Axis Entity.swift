//
//  Input Sphere Axis Entity.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit

extension InputSphereManager {
    
    internal func inputSphereAxisEntity(height: Float, radius: Float, material: Material, axis: InputSphereAxis) -> ModelEntity {
        let axisEntity = ModelEntity(
            mesh: MeshResource.generateCylinder(height: height, radius: radius),
            materials: [material]
        )

        axisEntity.orientation = axis.orientation ?? simd_quatf()

        let offset = SIMD3<Float>(
            x: axis == .lateral ? height / 2 : 0,
            y: axis == .vertical ? height / 2 : 0,
            z: axis == .longitudinal ? -height / 2 : 0
        )

        axisEntity.position = offset
        
        addAxisArrow(to: axisEntity, height: height, radius: radius, material: material)
        
        return axisEntity
    }
}
