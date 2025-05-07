//
//  Add Input Sphere.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 02.05.2025.
//

import SwiftUI
import RealityKit

extension InputSphereManager {
    
    /// Creates the Input Sphere, allowing the user to reposition it in space.
    /// - If the Input Sphere doesn’t exist, it is initialized as a mint-colored sphere.
    /// - The sphere is positioned slightly above the root point.
    public func addInputSphere(
        parentEntity: Entity,
        rootPoint: Entity?,
        color: Color = .mint,
        radius: Float = 0.015,
        showAxes: Bool = true) {
            
        guard let rootPoint = rootPoint else {
            print("Error: Failed to create Input Sphere. Root Point is nil.")
            return
        }
        
        guard inputSphere == nil else {
            print("Error: Failed to create Input Sphere. Input Sphere already exists.")
            return
        }

        let sphere = inputSphereEntity(color: color, radius: radius)
        sphere.position = rootPoint.position + SIMD3<Float>(0, 0.3, 0)
        sphere.setOrientation(.init(), relativeTo: rootPoint)
        parentEntity.addChild(sphere)
        
        inputSphere = sphere
        updateInputSpherePosition(rootPoint: rootPoint)
            
        if showAxes { addInputSphereAxes() }
    }
}

