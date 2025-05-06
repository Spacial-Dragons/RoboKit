//
//  Input Sphere Position String.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit

extension InputSphereManager {
    
    internal func inputSpherePositionString(relativeToRootPoint rootPoint: Entity) -> String? {
        guard let inputSphere else { return nil }
        let position = inputSpherePositionRelativeToRoot
        let positionInROS = position.convertToROSCoordinateSystem()
        
        let positionString = String(format:
            " x: %.3f m \t y: %.3f m \t z: %.3f m",
            positionInROS.x, positionInROS.y, positionInROS.z)
        
        return (positionString)
    }
}
