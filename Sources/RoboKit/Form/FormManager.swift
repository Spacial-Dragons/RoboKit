//
//  FormManager.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 20.05.2025.
//

import SwiftUI
import RealityKit

@MainActor
@Observable
public final class FormManager {

    public init() {}

    // Position in ROS
    public var formPositionRelativeToRoot: SIMD3<Float> = SIMD3<Float>(0, 0, 0.3)

    public var formEulerAngles: [EulerAngle: Float] = [
        .roll: 0,
        .yaw: 0,
        .pitch: 0
    ]
}
