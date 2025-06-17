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

extension InputEntityManager {
    /// Creates an entity representing the Input Entity with a 3D spherical model and input interaction components.
    ///
    /// - Parameters:
    ///   - color: The color applied to the sphere’s material.
    ///   - radius: The radius of the spherical mesh.
    ///   - modelEntity: An optional `Entity` to use
    ///   instead of the default spherical mesh. If `nil`, a sphere is generated automatically.
    ///
    /// - Returns: A fully configured `Entity` representing the Input Entity.
    internal func inputEntityEntity(
        color: Color,
        radius: Float,
        modelEntity: Entity? = nil
    ) -> Entity {
        logInputEntityCreationParameters(color: color, radius: radius)

        let entity = Entity()
        let entityRadius: Float

        if let customEntity = modelEntity {
            // Use the passed-in ModelComponent
            entity.addChild(customEntity)
            entityRadius = customEntity.visualBounds(relativeTo: nil).boundingRadius
            logModelEntityParameters(modelEntity: customEntity)
        } else {
            // Fall back to generating a default sphere
            setupSphereModelComponent(for: entity, color: color, radius: radius)
            entityRadius = radius
        }

        setupInteractionComponents(for: entity, radius: entityRadius)
        logSuccessfulInputEntityCreation(color: color, radius: entityRadius)

        return entity
    }

    /// Sets up the fallback model component for the Input Entity entity.
    ///
    /// - Parameters:
    ///   - entity: The entity to configure.
    ///   - color: The color for the sphere's material.
    ///   - radius: The radius of the sphere.
    private func setupSphereModelComponent(for entity: Entity, color: Color, radius: Float) {
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

    /// Sets up the interaction components for the Input Entity entity.
    ///
    /// - Parameters:
    ///   - entity: The entity to configure.
    ///   - radius: The radius of the sphere.
    private func setupInteractionComponents(for entity: Entity, radius: Float) {
        let collisionShape = ShapeResource.generateSphere(radius: radius)

        entity.components.set([
            CollisionComponent(shapes: [collisionShape]),
            InputTargetComponent(),
            HoverEffectComponent(),
            AccessibilityComponent()
        ])

        entity.isAccessibilityElement = true

        // Localization key for the label
        entity.accessibilityLabelKey = "Input Component"

        // Value description for the entity
        entity.accessibilityValue = "An input component to interact with and manipulate a robot"

        // Trait to describe the entity's behavior or role
        entity.accessibilityTraits = [.allowsDirectInteraction]

        logInteractionComponentsSetup(radius: radius)
    }

    /// Logs the initial parameters for input entity creation.
    private func logInputEntityCreationParameters(color: Color, radius: Float) {
        AppLogger.shared.debug(
            "Creating Input Entity entity",
            category: .inputEntity,
            context: [
                "color": String(describing: color),
                "radius": radius
            ]
        )
    }

    /// Logs parameters of the custom model entity
    private func logModelEntityParameters(modelEntity: Entity) {
        AppLogger.shared.debug(
            "Applied Model Entity to the Input Entity",
            category: .inputEntity,
            context: [
                "Entity Name": modelEntity.name
            ]
        )
    }

    /// Logs the model component setup details.
    private func logModelComponentSetup(radius: Float, materialType: Any.Type) {
        AppLogger.shared.debug(
            "Input Entity model component configured",
            category: .inputEntity,
            context: [
                "meshRadius": radius,
                "materialType": String(describing: materialType)
            ]
        )
    }

    /// Logs the interaction components setup details.
    private func logInteractionComponentsSetup(radius: Float) {
        AppLogger.shared.debug(
            "Input Entity interaction components configured",
            category: .inputEntity,
            context: [
                "hasCollisionComponent": true,
                "hasInputTargetComponent": true,
                "hasHoverEffectComponent": true,
                "collisionShapeRadius": radius
            ]
        )
    }

    /// Logs the successful creation of the Input Entity entity.
    private func logSuccessfulInputEntityCreation(color: Color, radius: Float) {
        AppLogger.shared.info(
            "Input Entity entity created successfully",
            category: .inputEntity,
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
