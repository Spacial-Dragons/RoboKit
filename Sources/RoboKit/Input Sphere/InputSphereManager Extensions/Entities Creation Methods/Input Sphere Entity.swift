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
        let entity = Entity()

        let simpleMaterial = SimpleMaterial(
            color: UIColor(color), isMetallic: true
        )

        let model = ModelComponent(
            mesh: .generateSphere(radius: radius),
            materials: [simpleMaterial]
        )
        entity.components.set(model)

        let collisionShape = ShapeResource.generateSphere(radius: radius)

        entity.components.set([
            CollisionComponent(shapes: [collisionShape]),
            InputTargetComponent(),
            HoverEffectComponent()
        ])

        return entity
    }
}
