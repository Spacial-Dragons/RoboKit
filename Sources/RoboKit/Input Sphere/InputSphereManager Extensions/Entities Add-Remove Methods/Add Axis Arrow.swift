//
//  Add Axis Arrow.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit

extension InputSphereManager {
    internal func addAxisArrow(to axisEntity: Entity, height: Float, radius: Float, material: Material) {
        let arrowEntity = axisArrowEntity(height: height, radius: radius, material: material)
        arrowEntity.position = SIMD3<Float>(0, height / 2, 0)
        axisEntity.addChild(arrowEntity)
    }
}
