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

extension InputEntityManager {
    /// Adds axis entities to the Input Entity.
    ///
    /// This method creates and attaches visual representations for the lateral, vertical,
    /// and longitudinal axes of the Input Entity.
    /// The axes are added as child entities of the Input Entity.
    ///
    /// If the Input Entity does not exist, the method exits without making changes.
    public func addInputEntityAxes() {
        guard let inputEntity = inputEntity else {
            AppLogger.shared.warning(
                "Attempted to add Input Entity axes but entity is nil",
                category: .inputEntity
            )
            return
        }

        let axes: [InputEntityAxis] = [.lateral, .vertical, .longitudinal]

        // Log the start of axes addition at debug level
        AppLogger.shared.debug(
            "Adding Input Entity axes",
            category: .inputEntity,
            context: [
                "axes": axes.map { $0.rawValue },
                "inputEntityPosition": inputEntity.position
            ]
        )

        for axis in axes {
            let axisEntity = inputEntityAxisEntity(
                height: 0.1,
                radius: 0.002,
                material: axis.material,
                axis: axis
            )
            inputEntityAxes[axis] = axisEntity
            inputEntity.addChild(axisEntity)

            // Log each axis addition at debug level
            AppLogger.shared.debug(
                "Added axis to Input Entity",
                category: .inputEntity,
                context: [
                    "axis": axis.rawValue,
                    "axisPosition": axisEntity.position,
                    "axisMaterial": String(describing: axis.material)
                ]
            )
        }

        // Log successful completion of axes addition at info level
        AppLogger.shared.info(
            "Input Entity axes added successfully",
            category: .inputEntity,
            context: [
                "axesCount": axes.count,
                "axesTypes": axes.map { $0.rawValue },
                "inputEntityPosition": inputEntity.position
            ]
        )
    }

    /// Removes all axis entities from the Input Entity.
    ///
    /// This method detaches and clears all previously added axis entities from the Input Entity.
    /// If no Input Entity is present, the method exits without making changes.
    public func removeInputEntityAxes() {
        guard let inputEntity = inputEntity else {
            AppLogger.shared.warning(
                "Attempted to remove Input Entity axes but entity is nil",
                category: .inputEntity
            )
            return
        }

        // Log the start of axes removal at debug level
        AppLogger.shared.debug(
            "Removing Input Entity axes",
            category: .inputEntity,
            context: [
                "currentAxesCount": inputEntityAxes.count,
                "axesTypes": inputEntityAxes.keys.map { $0.rawValue }
            ]
        )

        for (axis, axisEntity) in inputEntityAxes {
            // Log each axis removal at debug level
            AppLogger.shared.debug(
                "Removing axis from Input Entity",
                category: .inputEntity,
                context: [
                    "axis": axis.rawValue,
                    "axisPosition": axisEntity.position
                ]
            )
            axisEntity.removeFromParent()
        }

        let removedAxesCount = inputEntityAxes.count
        inputEntityAxes.removeAll()

        // Log successful completion of axes removal at info level
        AppLogger.shared.info(
            "Input Entity axes removed successfully",
            category: .inputEntity,
            context: [
                "removedAxesCount": removedAxesCount,
                "inputEntityPosition": inputEntity.position
            ]
        )
    }
}
