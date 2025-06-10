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

import Foundation

extension FormManager {
    public func updateFormPosition() {
        formPositionRelativeToRoot = formPositionRelativeToRootROS.convertToRealityKitCoordinateSystem()
    }
}
