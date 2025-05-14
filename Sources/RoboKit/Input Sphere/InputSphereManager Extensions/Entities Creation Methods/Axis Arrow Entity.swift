//
//  Axis Arrow Entity.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit

extension InputSphereManager {
    /// Creates a model entity representing an arrow for an axis.
    ///
    /// This method generates a cone-shaped mesh to visually represent the arrowhead of an axis.
    /// The arrow is scaled based on the provided height and radius parameters, and styled using
    /// the given `Material`.
    ///
    /// - Parameters:
    ///   - height: The total height of the axis entity, used to determine the arrow's size proportionally.
    ///   - radius: The base radius of the axis shaft, used to scale the arrow's radius.
    ///   - material: The material applied to the arrow mesh.
    /// - Returns: A `ModelEntity` containing the arrow geometry and material.
    internal func axisArrowEntity(height: Float, radius: Float, material: Material) -> ModelEntity {
        // Log arrow creation parameters at debug level
        AppLogger.shared.debug(
            "Creating axis arrow entity",
            category: .inputsphere,
            context: [
                "arrowHeight": height,
                "arrowRadius": radius,
                "materialType": String(describing: type(of: material))
            ]
        )
        
        let arrowMesh = MeshResource.generateCone(height: height * 0.2, radius: radius * 3)
        let entity = ModelEntity(mesh: arrowMesh, materials: [material])
        
        // Log successful arrow creation at debug level
        AppLogger.shared.debug(
            "Axis arrow entity created",
            category: .inputsphere,
            context: [
                "arrowDimensions": [
                    "height": height * 0.2,
                    "radius": radius * 3
                ],
                "entityPosition": entity.position
            ]
        )
        
        return entity
    }
}
