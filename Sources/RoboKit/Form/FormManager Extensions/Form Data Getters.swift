//
// ===----------------------------------------------------------------------=== //
//
// This source file is part of the RoboKit open source project
//
//
// Licensed under MIT
//
// See LICENSE for license information
// See "Contributors" section on GitHub for the list of project authors
//
// SPDX-License-Identifier: MIT
//
// ===----------------------------------------------------------------------=== //

import simd

extension FormManager {
    public func getFormPosition() -> SIMD3<Float> {
        let position = formPositionRelativeToRootROS
        return position
    }

    public func getFormRotation() -> simd_float3x3 {
        let rotation = formRotationRelativeToRoot.convertToROSCoordinateSystem()
        return rotation
    }
}
