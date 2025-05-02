//
//  Input Sphere Entity.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 02.05.2025.
//

import SwiftUI
import RealityKit

extension InputSphereManager {
    
    internal func inputSphereEntity(color: Color, radius: Float) -> Entity {
        let entity = Entity()
        
        let simpleMaterial = SimpleMaterial(
            color: UIColor(color), isMetallic: true
        )
        
        let model = ModelComponent(
            mesh: .generateSphere(radius: radius),
            materials: [simpleMaterial]
        )
        entity.components.set(model)

        let collisionShape = ShapeResource.generateSphere(radius: radius)
        
        entity.components.set([
            CollisionComponent(shapes: [collisionShape]),
            InputTargetComponent(),
            HoverEffectComponent()
        ])
        
        entity.name = inputSphereName
        return entity
    }
}
