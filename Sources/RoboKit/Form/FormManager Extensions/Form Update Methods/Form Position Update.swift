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

import Foundation

extension FormManager {
    /// Updates the form position in RealityKit coordinate system based on ROS coordinates.
    ///
    /// This method synchronizes the `formPositionRelativeToRoot` property by converting
    /// the current ROS coordinate system position to RealityKit coordinate system.
    /// The conversion accounts for the different axis orientations between the two systems.
    ///
    /// This method is automatically called when `formPositionRelativeToRootROS` is modified
    /// due to the `didSet` property observer.
    ///
    /// - Note: This method performs coordinate system conversion using `convertToRealityKitCoordinateSystem()`.
    /// - SeeAlso: `formPositionRelativeToRootROS` for the source ROS coordinates.
    /// - SeeAlso: `formPositionRelativeToRoot` for the target RealityKit coordinates.

    public func updateFormPosition() {
        formPositionRelativeToRoot = formPositionRelativeToRootROS.convertToRealityKitCoordinateSystem()
    }
}
