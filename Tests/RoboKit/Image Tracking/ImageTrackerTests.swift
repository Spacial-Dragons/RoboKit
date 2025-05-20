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
import simd
@testable import RoboKit

@MainActor
@Suite("Image Tracker")
struct ImageTrackerTests {

    private let trackingImagesConfig: [TrackingImage]
    private var tracker: ImageTracker

    init() throws {
        self.trackingImagesConfig = [
            try TrackingImage(imageName: "internal_img_1", rootOffset: .init(x: 1.1, y: 2.2, z: 3.0)),
            try TrackingImage(imageName: "internal_img_2", rootOffset: .init(x: -1.0, y: -3.5, z: 0.0)),
            try TrackingImage(imageName: "internal_img_3", rootOffset: .init(x: 10.2, y: -10.2, z: -3.0))
        ]

        self.tracker = try .init(
            arResourceGroupName: "RoboKitTestsArResourceGroup",
            images: trackingImagesConfig
        )
    }

    @Test("Get tracked images transform")
    func getTrackedImagesTransformTest() {
        // Test that getTrackedImagesTransform() returns the expected default transforms in simulator.

        let trackedImagesTransforms: [simd_float4x4] = tracker.getTrackedImagesTransform()
        #expect(trackedImagesTransforms.count == trackingImagesConfig.count)

        let expectedOffsets = trackingImagesConfig.map { $0.rootOffset }
        let actualOffsets = trackedImagesTransforms.map { $0.position }

        for expected in expectedOffsets {
            #expect(actualOffsets.contains(where: { $0 == expected }))
        }
    }

    @Test("Compute root position in simulator")
    func computeRootPositionSimulatorTest() {
        /// Test the averaging logic in computeRootPosition() for correctly computing
        /// the root transform based on multiple anchors.
        let rootPosition = tracker.computeRootPosition()
        #expect(rootPosition?.position == .zero)
    }

}
