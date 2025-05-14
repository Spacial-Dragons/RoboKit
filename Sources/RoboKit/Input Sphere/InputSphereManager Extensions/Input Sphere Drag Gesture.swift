//
//  Input Sphere Drag Gesture.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

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

        let oldPosition = value.entity.position
        value.entity.position = value.convert(value.location3D, from: .local, to: parentEntity)
        updateInputSpherePosition(rootPoint: rootPoint)

        // Log significant position changes during drag
        if oldPosition != value.entity.position {
            // Log detailed drag updates at debug level
            AppLogger.shared.debug(
                "Input Sphere dragged",
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
            // Log gesture setup at debug level
            AppLogger.shared.debug(
                "Input Sphere drag gesture enabled",
                category: .inputsphere,
                context: [
                    "hasInputSphere": true,
                    "hasRootPoint": true
                ]
            )

            // Log successful gesture setup at info level
            AppLogger.shared.info(
                "Input Sphere drag gesture initialized",
                category: .inputsphere,
                context: [
                    "inputSpherePosition": inputSphere.position,
                    "parentEntityName": parentEntity.name,
                    "rootPointPosition": rootPoint.position
                ]
            )

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
            // Log gesture setup failure at warning level
            AppLogger.shared.warning(
                "Input Sphere drag gesture not enabled",
                category: .inputsphere,
                context: [
                    "hasInputSphere": inputSphereManager.inputSphere != nil,
                    "hasRootPoint": rootPoint != nil
                ]
            )
            return AnyView(self)
        }
    }
}
