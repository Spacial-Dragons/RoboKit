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
    /// Updates and stores the current position of the Input Sphere.
    ///
    /// This method retrieves the position of the `inputSphere` relative to both its parent entity
    /// and the specified root point. It stores these values in the
    /// `inputSpherePositionRelativeToParent` and `inputSpherePositionRelativeToRoot`
    /// properties, respectively.
    ///
    /// - Parameter rootPoint: The reference entity used to calculate the Input Sphere’s position
    ///   relative to the global context.
    ///
    /// If `inputSphere` is `nil`, this method performs no action.
    public func updateInputSpherePosition(rootPoint: Entity) {
        if let inputSphere {
            self.inputSpherePositionRelativeToParent = inputSphere.position
            self.inputSpherePositionRelativeToRoot = inputSphere.position(relativeTo: rootPoint)
        }
    }
}
