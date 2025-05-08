//
//  Radians to Degrees.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 04.05.2025.
//

import Foundation

extension Float {
    public var toDegrees: Float {
        return self * 180 / .pi
    }
}
