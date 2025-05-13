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
    /// Handles updates to the Input Sphere's position during a drag gesture.
    ///
    /// This method recalculates the position of the Input Sphere based on the drag gesture's
    /// current 3D location relative to the specified parent entity. After updating the position,
    /// it also updates the stored position values relative to the root point.
    ///
    /// - Parameters:
    ///   - value: A drag gesture value targeted to an entity, providing 3D location updates.
    ///   - parentEntity: The entity relative to which the new position should be computed.
    ///   - rootPoint: The reference entity used to update internal position tracking.
    internal func handleInputSphereDragGesture(
        _ value: EntityTargetValue<DragGesture.Value>,
        parentEntity: Entity,
        rootPoint: Entity) {
        value.entity.position = value.convert(value.location3D, from: .local, to: parentEntity)
        updateInputSpherePosition(rootPoint: rootPoint)
    }
}

extension View {
    /// Adds a drag gesture recognizer to the view that enables manipulation of the Input Sphere in 3D space.
    ///
    /// This modifier attaches a drag gesture to the view, allowing users to reposition the Input Sphere entity
    /// interactively. The position is updated relative to the specified `parentEntity`, and internal state is
    /// updated using the provided `InputSphereManager` instance.
    ///
    /// - Parameters:
    ///   - parentEntity: The parent entity relative to which the Input Sphere's position will be calculated.
    ///   - rootPoint: The reference root point entity used to update the Input Sphere's position data.
    ///   - inputSphereManager: The `InputSphereManager` instance responsible for managing Input Sphere state.
    /// - Returns: A view modified with the gesture recognizer if prerequisites are met, otherwise the original view.
    public func inputSphereDragGesture(
        parentEntity: Entity,
        rootPoint: Entity?,
        inputSphereManager: InputSphereManager
    ) -> some View {
        if let inputSphere = inputSphereManager.inputSphere, let rootPoint = rootPoint {
            return AnyView(
                self.gesture(
                    DragGesture()
                        .targetedToEntity(inputSphere)
                        .onChanged { value in
                            inputSphereManager.handleInputSphereDragGesture(
                                value,
                                parentEntity: parentEntity,
                                rootPoint: rootPoint
                            )
                        }
                )
            )
        } else {
            return AnyView(self)
        }
    }
}
