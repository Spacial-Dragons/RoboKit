//
//  Add Input Sphere Axes.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit

extension InputSphereManager {
    public func addInputSphereAxes() {
        guard let inputSphere = inputSphere else { return }
        let axes: [InputSphereAxis] = [.lateral, .vertical, .longitudinal]
//        updateInputSpherePosition()
        
        for axis in axes {
            let axisEntity = inputSphereAxisEntity(
                height: 0.1,
                radius: 0.002,
                material: axis.material,
                axis: axis
            )
            inputSphereAxes[axis] = axisEntity
            inputSphere.addChild(axisEntity)
        }
    }
    
    public func removeInputSphereAxes() {
        guard let inputSphere = inputSphere else { return }
        
        for (_, axisEntity) in inputSphereAxes {
            axisEntity.removeFromParent()
        }
        
        inputSphereAxes.removeAll()
    }
}
