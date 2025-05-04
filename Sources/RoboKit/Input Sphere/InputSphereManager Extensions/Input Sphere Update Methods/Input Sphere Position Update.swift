//
//  Input Sphere Position Update.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

extension InputSphereManager {
    
    /// Updates and stores the current position of the input sphere.
    internal func updateInputSpherePosition() {
        if let inputSphere {
            self.inputSpherePosition = inputSphere.position
        }
    }
}
