//
//  InputSpherePositionText.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 03.05.2025.
//

import RealityKit
import SwiftUI

public struct InputSpherePositionText: View {
    @Environment(InputSphereManager.self) private var inputSphereManager: InputSphereManager
    private let axis: Axis
    
    public init(axis: Axis) {
        self.axis = axis
    }
    
    private var positionValue: Float? {
        guard let position = inputSphereManager.inputSpherePositionRelativeToRoot
        else { return nil }
        let positionInROS = position.convertToROSCoordinateSystem()
        
        switch axis {
        case .lateral: return positionInROS.x
        case .longitudinal: return positionInROS.y
        case .vertical: return positionInROS.z
        }
    }
    
    private var axisLabel: String {
        switch axis {
        case .lateral: return "X"
        case .longitudinal: return "Y"
        case .vertical: return "Z"
        }
    }
    
    public var body: some View {
        HStack(spacing: 20) {
            Text(axisLabel)
            Text(positionValue.map { String(format: "%.3f", $0) } ?? "NA")
        }
    }
}
