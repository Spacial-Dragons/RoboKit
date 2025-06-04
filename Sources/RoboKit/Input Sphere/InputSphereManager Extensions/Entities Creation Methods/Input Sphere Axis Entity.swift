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
    /// Creates a model entity representing one of the Input Sphere's axes.
    ///
    /// This method constructs a cylindrical mesh aligned along the specified axis and applies
    /// a corresponding orientation and position offset to visually align it within the 3D space.
    /// It also adds an arrowhead to the axis using `addAxisArrow(to:height:radius:material:)`
    /// for clearer directional indication.
    ///
    /// - Parameters:
    ///   - height: The height of the cylindrical axis.
    ///   - radius: The radius of the cylindrical axis.
    ///   - material: The visual material applied to the axis mesh.
    ///   - axis: The axis being represented—either `.lateral`, `.vertical`, or `.longitudinal`.
    ///
    /// - Returns: A `ModelEntity` representing the visualized axis, including an arrowhead.
    internal func inputSphereAxisEntity(
        height: Float,
        radius: Float,
        material: Material,
        axis: InputSphereAxis) -> ModelEntity {

        // Log axis creation parameters at debug level
        AppLogger.shared.debug(
            "Creating Input Sphere axis entity",
            category: .inputsphere,
            context: [
                "axis": axis.rawValue,
                "height": height,
                "radius": radius,
                "materialType": String(describing: type(of: material))
            ]
        )

        let axisEntity = ModelEntity(
            mesh: MeshResource.generateCylinder(height: height, radius: radius),
            materials: [material]
        )

        axisEntity.orientation = axis.orientation ?? simd_quatf()

        let offset = SIMD3<Float>(
            x: axis == .lateral ? height / 2 : 0,
            y: axis == .vertical ? height / 2 : 0,
            z: axis == .longitudinal ? -height / 2 : 0
        )

        axisEntity.position = offset

        // Log axis entity configuration at debug level
        AppLogger.shared.debug(
            "Input Sphere axis entity configured",
            category: .inputsphere,
            context: [
                "axis": axis.rawValue,
                "orientation": axisEntity.orientation,
                "position": axisEntity.position,
                "offset": offset
            ]
        )

        addAxisArrow(to: axisEntity, height: height, radius: radius, material: material)

        // Log successful axis entity creation at info level
        AppLogger.shared.info(
            "Input Sphere axis entity created successfully",
            category: .inputsphere,
            context: [
                "axis": axis.rawValue,
                "finalPosition": axisEntity.position,
                "finalOrientation": axisEntity.orientation,
                "dimensions": [
                    "height": height,
                    "radius": radius
                ]
            ]
        )

        return axisEntity
    }
}
