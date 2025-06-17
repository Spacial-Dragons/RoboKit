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
    /// Updates and stores the current position of the Input Entity.
    ///
    /// This method retrieves the position of the `inputEntity` relative to both its parent entity
    /// and the specified root point. It stores these values in the
    /// `inputEntityPositionRelativeToParent` and `inputEntityPositionRelativeToRoot`
    /// properties, respectively.
    ///
    /// - Parameter rootPoint: The reference entity used to calculate the Input Entity’s position
    ///   relative to the global context.
    ///
    /// If `inputEntity` is `nil`, this method performs no action.
    public func updateInputEntityPosition(relativeToRootPoint rootPoint: Entity) {
        if let inputEntity {
            self.inputEntityPositionRelativeToParent = inputEntity.position
            self.inputEntityPositionRelativeToRoot = inputEntity.position(relativeTo: rootPoint)
        } else {
            AppLogger.shared.warning(
                "Attempted to update Input Entity position but entity is nil",
                category: .inputEntity
            )
        }
    }
}
