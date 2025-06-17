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
    /// Adds the Input Entity entity to the specified parent entity.
    ///
    /// The Input Entity represents the target position and orientation of a robot's end effector.
    /// This method positions the Input Entity above the provided root point and optionally displays its axes.
    ///
    /// - Parameters:
    ///   - parentEntity: The entity to which the Input Entity will be added as a child.
    ///   - rootPoint: The origin of robot's frame of reference.
    ///   - color: The color of the Input Entity. Defaults to `.mint`.
    ///   - radius: The radius of the sphere. Defaults to `0.015`.
    ///   - showAxes: A Boolean value indicating whether to display Input Entity's axes. Defaults to `true`.
    ///   - modelEntity: An optional `Entity` to use
    ///   instead of the default spherical mesh. If `nil`, a sphere is generated automatically.
    ///
    /// If the root point is `nil` or the Input Entity has already been created,
    /// the method exits early and logs an error.
    public func addInputEntity(
        parentEntity: Entity,
        rootPoint: Entity?,
        color: Color = .mint,
        radius: Float = 0.015,
        modelEntity: Entity? = nil,
        showAxes: Bool = true
    ) {
        guard let rootPoint = rootPoint else {
            AppLogger.shared.error(
                "Failed to create Input Entity: Root Point is nil",
                category: .inputEntity
            )
            return
        }

        guard inputEntity == nil else {
            AppLogger.shared.error(
                "Failed to create Input Entity: Input Entity already exists",
                category: .inputEntity
            )
            return
        }

        let sphere = inputSphereEntity(color: color, radius: radius, modelEntity: modelEntity)
        sphere.position = rootPoint.position + SIMD3<Float>(0, 0.3, 0)
        sphere.setOrientation(.init(), relativeTo: rootPoint)
        parentEntity.addChild(sphere)

        inputEntity = sphere
        updateInputSpherePosition(relativeToRootPoint: rootPoint)

        AppLogger.shared.info(
            "Input Sphere created successfully",
            category: .inputEntity,
            context: [
                "position": sphere.position,
                "radius": radius,
                "showAxes": showAxes
            ]
        )

        if showAxes {
            addInputSphereAxes()
            AppLogger.shared.debug(
                "Input Sphere axes added",
                category: .inputEntity
            )
        }
    }
}
