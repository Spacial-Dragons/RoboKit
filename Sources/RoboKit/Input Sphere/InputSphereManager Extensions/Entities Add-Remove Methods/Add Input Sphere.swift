//
//  Add Input Sphere.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 02.05.2025.
//

import SwiftUI
import RealityKit

extension InputSphereManager {
    /// Adds the Input Sphere entity to the specified parent entity.
    ///
    /// The Input Sphere represents the target position and orientation of a robot's end effector.
    /// This method positions the Input Sphere above the provided root point and optionally displays its axes.
    ///
    /// - Parameters:
    ///   - parentEntity: The entity to which the Input Sphere will be added as a child.
    ///   - rootPoint: The origin of robot's frame of reference.
    ///   - color: The color of the Input Sphere. Defaults to `.mint`.
    ///   - radius: The radius of the sphere. Defaults to `0.015`.
    ///   - showAxes: A Boolean value indicating whether to display Input Sphere's axes. Defaults to `true`.
    ///
    /// If the root point is `nil` or the Input Sphere has already been created,
    /// the method exits early and logs an error.
    public func addInputSphere(
        parentEntity: Entity,
        rootPoint: Entity?,
        color: Color = .mint,
        radius: Float = 0.015,
        showAxes: Bool = true) {

        guard let rootPoint = rootPoint else {
            AppLogger.shared.error(
                "Failed to create Input Sphere: Root Point is nil",
                category: .inputsphere
            )
            return
        }

        guard inputSphere == nil else {
            AppLogger.shared.error(
                "Failed to create Input Sphere: Input Sphere already exists",
                category: .inputsphere
            )
            return
        }

        let sphere = inputSphereEntity(color: color, radius: radius)
        sphere.position = rootPoint.position + SIMD3<Float>(0, 0.3, 0)
        sphere.setOrientation(.init(), relativeTo: rootPoint)
        parentEntity.addChild(sphere)

        inputSphere = sphere
        updateInputSpherePosition(rootPoint: rootPoint)

        AppLogger.shared.info(
            "Input Sphere created successfully",
            category: .inputsphere,
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
                category: .inputsphere
            )
        }
    }
}
