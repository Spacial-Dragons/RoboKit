//
//  Input Sphere Position Update.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit

extension InputSphereManager {

    /// Updates and stores the current position of the input sphere.
    public func updateInputSpherePosition(rootPoint: Entity) {
        if let inputSphere {
            self.inputSpherePositionRelativeToParent = inputSphere.position
            self.inputSpherePositionRelativeToRoot = inputSphere.position(relativeTo: rootPoint)
        }
    }
}
