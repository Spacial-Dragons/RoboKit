//
//  Input Sphere Position String.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

extension InputSphereManager {
    
    internal func inputSpherePositionString() -> String {
        let positionInROS = inputSpherePosition.convertToROSCoordinateSystem()
        
        let positionString = String(format:
            " x: %.3f m \t y: %.3f m \t z: %.3f m",
            positionInROS.x, positionInROS.y, positionInROS.z)
        
        return (positionString)
    }
}
