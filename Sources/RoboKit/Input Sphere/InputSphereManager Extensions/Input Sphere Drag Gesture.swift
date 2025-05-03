//
//  Input Sphere Drag Gesture.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import SwiftUI
import RealityKit

extension InputSphereManager {
    internal func handleInputSphereDragGesture(_ value: EntityTargetValue<DragGesture.Value>, parentEntity: Entity) {
        value.entity.position = value.convert(value.location3D, from: .local, to: parentEntity)
        updateInputSpherePosition()
    }
}

extension View {
    public func inputSphereDragGesture(
        parentEntity: Entity,
        inputSphereManager: InputSphereManager
    ) -> some View {
        if let inputSphere = inputSphereManager.inputSphere {
            return AnyView(
                self.gesture(
                    DragGesture()
                        .targetedToEntity(inputSphere)
                        .onChanged { value in
                            inputSphereManager.handleInputSphereDragGesture(
                                value,
                                parentEntity: parentEntity
                            )
                        }
                )
            )
        } else {
            return AnyView(self)
        }
    }
}
