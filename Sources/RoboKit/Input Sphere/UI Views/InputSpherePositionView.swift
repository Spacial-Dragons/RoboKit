//
//  InputSpherePositionView.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit
import SwiftUI

public struct InputSpherePositionView: View {
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    let rootPoint: Entity
    private var positionString: String? {
        return inputSphereManager.inputSpherePositionString(relativeToRootPoint: rootPoint)
    }

    public init(relativeToRootPoint rootPoint: Entity) {
        self.rootPoint = rootPoint
    }

    public var body: some View {
        Text(positionString ?? "NA")
    }
}
