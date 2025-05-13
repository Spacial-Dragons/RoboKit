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
            print("Error: Failed to create Input Sphere. Root Point is nil.")
            return
        }

        guard inputSphere == nil else {
            print("Error: Failed to create Input Sphere. Input Sphere already exists.")
            return
        }

        let sphere = inputSphereEntity(color: color, radius: radius)
        sphere.position = rootPoint.position + SIMD3<Float>(0, 0.3, 0)
        sphere.setOrientation(.init(), relativeTo: rootPoint)
        parentEntity.addChild(sphere)

        inputSphere = sphere
        updateInputSpherePosition(rootPoint: rootPoint)

        if showAxes { addInputSphereAxes() }
    }
}
