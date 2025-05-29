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
    /// Adds axis entities to the Input Sphere.
    ///
    /// This method creates and attaches visual representations for the lateral, vertical,
    /// and longitudinal axes of the Input Sphere.
    /// The axes are added as child entities of the Input Sphere.
    ///
    /// If the Input Sphere does not exist, the method exits without making changes.
    public func addInputSphereAxes() {
        guard let inputSphere = inputSphere else {
            AppLogger.shared.warning(
                "Attempted to add Input Sphere axes but sphere is nil",
                category: .inputsphere
            )
            return
        }

        let axes: [InputSphereAxis] = [.lateral, .vertical, .longitudinal]

        // Log the start of axes addition at debug level
        AppLogger.shared.debug(
            "Adding Input Sphere axes",
            category: .inputsphere,
            context: [
                "axes": axes.map { $0.rawValue },
                "inputSpherePosition": inputSphere.position
            ]
        )

        for axis in axes {
            let axisEntity = inputSphereAxisEntity(
                height: 0.1,
                radius: 0.002,
                material: axis.material,
                axis: axis
            )
            inputSphereAxes[axis] = axisEntity
            inputSphere.addChild(axisEntity)

            // Log each axis addition at debug level
            AppLogger.shared.debug(
                "Added axis to Input Sphere",
                category: .inputsphere,
                context: [
                    "axis": axis.rawValue,
                    "axisPosition": axisEntity.position,
                    "axisMaterial": String(describing: axis.material)
                ]
            )
        }

        // Log successful completion of axes addition at info level
        AppLogger.shared.info(
            "Input Sphere axes added successfully",
            category: .inputsphere,
            context: [
                "axesCount": axes.count,
                "axesTypes": axes.map { $0.rawValue },
                "inputSpherePosition": inputSphere.position
            ]
        )
    }

    /// Removes all axis entities from the Input Sphere.
    ///
    /// This method detaches and clears all previously added axis entities from the Input Sphere.
    /// If no Input Sphere is present, the method exits without making changes.
    public func removeInputSphereAxes() {
        guard let inputSphere = inputSphere else {
            AppLogger.shared.warning(
                "Attempted to remove Input Sphere axes but sphere is nil",
                category: .inputsphere
            )
            return
        }

        // Log the start of axes removal at debug level
        AppLogger.shared.debug(
            "Removing Input Sphere axes",
            category: .inputsphere,
            context: [
                "currentAxesCount": inputSphereAxes.count,
                "axesTypes": inputSphereAxes.keys.map { $0.rawValue }
            ]
        )

        for (axis, axisEntity) in inputSphereAxes {
            // Log each axis removal at debug level
            AppLogger.shared.debug(
                "Removing axis from Input Sphere",
                category: .inputsphere,
                context: [
                    "axis": axis.rawValue,
                    "axisPosition": axisEntity.position
                ]
            )
            axisEntity.removeFromParent()
        }

        let removedAxesCount = inputSphereAxes.count
        inputSphereAxes.removeAll()

        // Log successful completion of axes removal at info level
        AppLogger.shared.info(
            "Input Sphere axes removed successfully",
            category: .inputsphere,
            context: [
                "removedAxesCount": removedAxesCount,
                "inputSpherePosition": inputSphere.position
            ]
        )
    }
}
