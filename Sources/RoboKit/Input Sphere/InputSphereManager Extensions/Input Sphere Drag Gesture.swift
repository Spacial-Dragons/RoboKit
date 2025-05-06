//
//  Input Sphere Drag Gesture.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import SwiftUI
import RealityKit

extension InputSphereManager {
    internal func handleInputSphereDragGesture(_ value: EntityTargetValue<DragGesture.Value>, parentEntity: Entity, rootPoint: Entity) {
        value.entity.position = value.convert(value.location3D, from: .local, to: parentEntity)
        updateInputSpherePosition(rootPoint: rootPoint)
    }
}

extension View {
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
