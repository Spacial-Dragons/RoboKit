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

extension InputEntityManager {
    /// Handles updates to the Input Entity's position during a drag gesture.
    ///
    /// This method recalculates the position of the Input Entity based on the drag gesture's
    /// current 3D location relative to the specified parent entity. After updating the position,
    /// it also updates the stored position values relative to the root point.
    ///
    /// - Parameters:
    ///   - value: A drag gesture value targeted to an entity, providing 3D location updates.
    ///   - parentEntity: The entity relative to which the new position should be computed.
    ///   - rootPoint: The reference entity used to update internal position tracking.
    internal func handleInputEntityDragGesture(
        _ value: EntityTargetValue<DragGesture.Value>,
        parentEntity: Entity,
        rootPoint: Entity) {

        let oldPosition = value.entity.position
        value.entity.position = value.convert(value.location3D, from: .local, to: parentEntity)
        updateInputEntityPosition(relativeToRootPoint: rootPoint)
        updateInputEntityRotation(relativeToRootPoint: rootPoint)

        // Log significant position changes during drag
        if oldPosition != value.entity.position {
            // Log detailed drag updates at debug level
            AppLogger.shared.debug(
                "Input Entity dragged",
                category: .tracking,
                context: [
                    "oldPosition": oldPosition,
                    "newPosition": value.entity.position,
                    "dragLocation": value.location3D
                ]
            )
        }
    }
}

extension View {
    /// Adds a drag gesture recognizer to the view that enables manipulation of the Input Entity in 3D space.
    ///
    /// This modifier attaches a drag gesture to the view, allowing users to reposition the Input Entity entity
    /// interactively. The position is updated relative to the specified `parentEntity`, and internal state is
    /// updated using the provided `InputEntityManager` instance.
    ///
    /// - Parameters:
    ///   - parentEntity: The parent entity relative to which the Input Entity's position will be calculated.
    ///   - rootPoint: The reference root point entity used to update the Input Entity's position data.
    ///   - inputEntityManager: The `InputEntityManager` instance responsible for managing Input Entity state.
    /// - Returns: A view modified with the gesture recognizer if prerequisites are met, otherwise the original view.
    public func inputEntityDragGesture(
        parentEntity: Entity,
        rootPoint: Entity?,
        inputEntityManager: InputEntityManager
    ) -> some View {
        if let inputEntity = inputEntityManager.inputEntity, let rootPoint = rootPoint {
            // Log gesture setup at debug level
            AppLogger.shared.debug(
                "Input Entity drag gesture enabled",
                category: .inputEntity,
                context: [
                    "hasInputEntity": true,
                    "hasRootPoint": true
                ]
            )

            // Log successful gesture setup at info level
            AppLogger.shared.info(
                "Input Entity drag gesture initialized",
                category: .inputEntity,
                context: [
                    "inputEntityPosition": inputEntity.position,
                    "parentEntityName": parentEntity.name,
                    "rootPointPosition": rootPoint.position
                ]
            )

            return AnyView(
                self.gesture(
                    DragGesture()
                        .targetedToEntity(inputEntity)
                        .onChanged { value in
                            inputEntityManager.handleInputEntityDragGesture(
                                value,
                                parentEntity: parentEntity,
                                rootPoint: rootPoint
                            )
                        }
                )
            )
        } else {
            // Log gesture setup failure at warning level
            AppLogger.shared.warning(
                "Input Entity drag gesture not enabled",
                category: .inputEntity,
                context: [
                    "hasInputEntity": inputEntityManager.inputEntity != nil,
                    "hasRootPoint": rootPoint != nil
                ]
            )
            return AnyView(self)
        }
    }
}
