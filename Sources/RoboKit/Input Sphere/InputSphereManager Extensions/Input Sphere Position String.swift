//
//  Input Sphere Position String.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit

extension InputSphereManager {
    /// Returns a formatted string representing the Input Sphere’s position relative to the given root point.
    ///
    /// This method converts the current position of the Input Sphere from the RealityKit coordinate system
    /// to the ROS coordinate system, then formats the result into a human-readable string.
    ///
    /// - Parameter rootPoint: The reference entity used to determine the Input Sphere’s relative position.
    /// - Returns: A string describing the position in meters along the x, y, and z axes in the ROS coordinate system,
    ///   or `nil` if the Input Sphere’s position relative to the root point is not available.
    internal func inputSpherePositionString(relativeToRootPoint rootPoint: Entity) -> String? {
        guard let position = inputSpherePositionRelativeToRoot else {
            AppLogger.shared.debug(
                "Failed to format Input Sphere position string: position is nil",
                category: .inputsphere
            )
            return nil
        }
        
        // Log position conversion at debug level
        AppLogger.shared.debug(
            "Converting Input Sphere position to ROS coordinates",
            category: .inputsphere,
            context: [
                "originalPosition": position,
                "relativeToRootPoint": rootPoint.position
            ]
        )
        
        let positionInROS = position.convertToROSCoordinateSystem()

        let positionString = String(format:
            " x: %.3f m \t y: %.3f m \t z: %.3f m",
            positionInROS.x, positionInROS.y, positionInROS.z)
        
        // Log formatted position string at debug level
        AppLogger.shared.debug(
            "Input Sphere position string formatted",
            category: .inputsphere,
            context: [
                "formattedString": positionString,
                "rosPosition": positionInROS
            ]
        )

        return (positionString)
    }
}
