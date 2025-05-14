//
//  Input Sphere Entity.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 02.05.2025.
//

import SwiftUI
import RealityKit

extension InputSphereManager {
    /// Creates an entity representing the Input Sphere with a 3D spherical model and input interaction components.
    ///
    /// This method initializes a new `Entity` configured with a metallic material of the specified color,
    /// a spherical mesh of the given radius, and essential RealityKit components to enable interaction,
    /// including collision detection and hover effects.
    ///
    /// - Parameters:
    ///   - color: The color applied to the sphere’s material.
    ///   - radius: The radius of the spherical mesh.
    ///
    /// - Returns: A fully configured `Entity` representing the Input Sphere.
    internal func inputSphereEntity(color: Color, radius: Float) -> Entity {
        // Log sphere creation parameters at debug level
        AppLogger.shared.debug(
            "Creating Input Sphere entity",
            category: .inputsphere,
            context: [
                "color": String(describing: color),
                "radius": radius
            ]
        )
        
        let entity = Entity()

        let simpleMaterial = SimpleMaterial(
            color: UIColor(color), isMetallic: true
        )

        let model = ModelComponent(
            mesh: .generateSphere(radius: radius),
            materials: [simpleMaterial]
        )
        entity.components.set(model)
        
        // Log model component setup at debug level
        AppLogger.shared.debug(
            "Input Sphere model component configured",
            category: .inputsphere,
            context: [
                "meshRadius": radius,
                "materialType": String(describing: type(of: simpleMaterial))
            ]
        )

        let collisionShape = ShapeResource.generateSphere(radius: radius)

        entity.components.set([
            CollisionComponent(shapes: [collisionShape]),
            InputTargetComponent(),
            HoverEffectComponent()
        ])
        
        // Log interaction components setup at debug level
        AppLogger.shared.debug(
            "Input Sphere interaction components configured",
            category: .inputsphere,
            context: [
                "hasCollisionComponent": true,
                "hasInputTargetComponent": true,
                "hasHoverEffectComponent": true,
                "collisionShapeRadius": radius
            ]
        )
        
        // Log successful sphere creation at info level
        AppLogger.shared.info(
            "Input Sphere entity created successfully",
            category: .inputsphere,
            context: [
                "finalRadius": radius,
                "color": String(describing: color),
                "components": [
                    "model": true,
                    "collision": true,
                    "inputTarget": true,
                    "hoverEffect": true
                ]
            ]
        )

        return entity
    }
}
