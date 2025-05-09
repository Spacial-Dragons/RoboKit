//
//  Add Axis Arrow.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit

extension InputSphereManager {
    /// Adds a visual arrow to represent an axis of the Input Sphere.
    ///
    /// This method creates an arrow-shaped `Entity` using the corresponding axis's height, radius, and material,
    /// positions it appropriately above the origin of the target axis entity, and attaches it as a child.
    ///
    /// - Parameters:
    ///   - axisEntity: The parent entity representing an axis to which the arrow will be added.
    ///   - height: The height of the corresponding axis.
    ///   - radius: The radius of the corresponding axis.
    ///   - material: The material of the corresponding axis.
    internal func addAxisArrow(to axisEntity: Entity, height: Float, radius: Float, material: Material) {
        let arrowEntity = axisArrowEntity(height: height, radius: radius, material: material)
        arrowEntity.position = SIMD3<Float>(0, height / 2, 0)
        axisEntity.addChild(arrowEntity)
    }
}
