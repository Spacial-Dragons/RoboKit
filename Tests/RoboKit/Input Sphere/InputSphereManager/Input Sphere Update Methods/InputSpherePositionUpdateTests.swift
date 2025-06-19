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

import Testing
import RealityKit
@testable import RoboKit

@Suite("InputEntityManager - Input Entity Update Methods")
@MainActor
struct UpdateInputEntityPositionTests {

    var manager = InputEntityManager()
    var root = Entity()
    var inputEntity = Entity()

    @Test("Input Entity position updates correctly")
    func testPositionUpdated() {
        inputEntity.position = [1, 2, 3]
        root.position = [0, 0, 1]

        manager.inputEntity = inputEntity
        manager.updateInputEntityPosition(relativeToRootPoint: root)

        #expect(manager.inputEntityPositionRelativeToParent == SIMD3<Float>(1, 2, 3))
        #expect(manager.inputEntityPositionRelativeToRoot == inputEntity.position(relativeTo: root))
    }
}
