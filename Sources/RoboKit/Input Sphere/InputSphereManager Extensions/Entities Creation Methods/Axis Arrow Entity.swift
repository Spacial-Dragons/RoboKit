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

import RealityKit

extension InputSphereManager {
    /// Creates a model entity representing an arrow for an axis.
    ///
    /// This method generates a cone-shaped mesh to visually represent the arrowhead of an axis.
    /// The arrow is scaled based on the provided height and radius parameters, and styled using
    /// the given `Material`.
    ///
    /// - Parameters:
    ///   - height: The total height of the axis entity, used to determine the arrow’s size proportionally.
    ///   - radius: The base radius of the axis shaft, used to scale the arrow’s radius.
    ///   - material: The material applied to the arrow mesh.
    /// - Returns: A `ModelEntity` containing the arrow geometry and material.
    internal func axisArrowEntity(height: Float, radius: Float, material: Material) -> ModelEntity {
        let arrowMesh = MeshResource.generateCone(height: height * 0.2, radius: radius * 3)
        return ModelEntity(mesh: arrowMesh, materials: [material])
    }
}
