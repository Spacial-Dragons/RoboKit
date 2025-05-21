//
//  SIMD Extensions.swift
//  RoboKit
//
//  Created by Mariia Chemerys on 21.05.2025.
//

import simd

/// Converts Position Vector to an array
public extension SIMD3 where Scalar == Float {
    var array: [Float] {
        [x, y, z]
    }
}
