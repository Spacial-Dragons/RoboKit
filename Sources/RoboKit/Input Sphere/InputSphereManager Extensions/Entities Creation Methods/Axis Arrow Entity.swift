//
//  Axis Arrow Entity.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit

extension InputSphereManager {
    
    internal func axisArrowEntity(height: Float, radius: Float, material: Material) -> ModelEntity {
        let arrowMesh = MeshResource.generateCone(height: height * 0.2, radius: radius * 3)
        return ModelEntity(mesh: arrowMesh, materials: [material])
    }
}
