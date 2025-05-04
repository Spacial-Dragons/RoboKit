//
//  PrintInputSphereDataButton.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import RealityKit
import SwiftUI

// The button prints positional and rotational data from Input Sphere to the console
public struct PrintInputSphereDataButton: View {
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    let rootPoint: Entity
    
    public init(relativeToRootPoint rootPoint: Entity) {
        self.rootPoint = rootPoint
    }
    
    public var body: some View {
        Button("Print Data") {
            guard let inputSphere = inputSphereManager.inputSphere else { return }
            let transformMatrix = inputSphere.transformMatrix(relativeTo: rootPoint)
            
            let position = transformMatrix.position.convertToROSCoordinateSystem()
            print("Input Sphere position: \(position)")
            
            let rotation = transformMatrix.rotationMatrix.convertToROSCoordinateSystem()
            print("Input Sphere rotation: \(rotation)")
        }
    }
}
