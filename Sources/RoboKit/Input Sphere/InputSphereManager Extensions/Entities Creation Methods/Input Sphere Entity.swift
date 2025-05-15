//
// ===----------------------------------------------------------------------=== //
//
// This source file is part of the RoboKit open source project
//
//
// Licensed under MIT
//
// See LICENSE for license information
// See "Contributors" section on GitHub for the list of project authors
//
// SPDX-License-Identifier: MIT
//
// ===----------------------------------------------------------------------=== //

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
        logSphereCreationParameters(color: color, radius: radius)

        let entity = Entity()
        setupModelComponent(for: entity, color: color, radius: radius)
        setupInteractionComponents(for: entity, radius: radius)
        logSuccessfulSphereCreation(color: color, radius: radius)

        return entity
    }

    /// Sets up the model component for the Input Sphere entity.
    ///
    /// - Parameters:
    ///   - entity: The entity to configure.
    ///   - color: The color for the sphere's material.
    ///   - radius: The radius of the sphere.
    private func setupModelComponent(for entity: Entity, color: Color, radius: Float) {
        let simpleMaterial = SimpleMaterial(
            color: UIColor(color), isMetallic: true
        )

        let model = ModelComponent(
            mesh: .generateSphere(radius: radius),
            materials: [simpleMaterial]
        )
        entity.components.set(model)

        logModelComponentSetup(radius: radius, materialType: type(of: simpleMaterial))
    }

    /// Sets up the interaction components for the Input Sphere entity.
    ///
    /// - Parameters:
    ///   - entity: The entity to configure.
    ///   - radius: The radius of the sphere.
    private func setupInteractionComponents(for entity: Entity, radius: Float) {
        let collisionShape = ShapeResource.generateSphere(radius: radius)

        entity.components.set([
            CollisionComponent(shapes: [collisionShape]),
            InputTargetComponent(),
            HoverEffectComponent()
        ])

        logInteractionComponentsSetup(radius: radius)
    }

    /// Logs the initial parameters for sphere creation.
    private func logSphereCreationParameters(color: Color, radius: Float) {
        AppLogger.shared.debug(
            "Creating Input Sphere entity",
            category: .inputsphere,
            context: [
                "color": String(describing: color),
                "radius": radius
            ]
        )
    }

    /// Logs the model component setup details.
    private func logModelComponentSetup(radius: Float, materialType: Any.Type) {
        AppLogger.shared.debug(
            "Input Sphere model component configured",
            category: .inputsphere,
            context: [
                "meshRadius": radius,
                "materialType": String(describing: materialType)
            ]
        )
    }

    /// Logs the interaction components setup details.
    private func logInteractionComponentsSetup(radius: Float) {
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
    }

    /// Logs the successful creation of the Input Sphere entity.
    private func logSuccessfulSphereCreation(color: Color, radius: Float) {
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
    }
}
