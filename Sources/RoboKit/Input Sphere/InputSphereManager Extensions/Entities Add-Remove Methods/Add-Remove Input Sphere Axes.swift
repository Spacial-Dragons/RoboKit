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
        guard let inputSphere = inputSphere else { return }

        let axes: [InputSphereAxis] = [.lateral, .vertical, .longitudinal]

        for axis in axes {
            let axisEntity = inputSphereAxisEntity(
                height: 0.1,
                radius: 0.002,
                material: axis.material,
                axis: axis
            )
            inputSphereAxes[axis] = axisEntity
            inputSphere.addChild(axisEntity)
        }
    }

    /// Removes all axis entities from the Input Sphere.
    ///
    /// This method detaches and clears all previously added axis entities from the Input Sphere.
    /// If no Input Sphere is present, the method exits without making changes.
    public func removeInputSphereAxes() {
        guard inputSphere != nil else { return }

        for (_, axisEntity) in inputSphereAxes {
            axisEntity.removeFromParent()
        }

        inputSphereAxes.removeAll()
    }
}
