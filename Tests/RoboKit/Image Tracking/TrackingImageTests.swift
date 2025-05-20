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
@testable import RoboKit

@MainActor
@Suite("Tracking Image")
struct TrackingImageTests {

    @Test("TrackingImage init succeeds when image exists in asset catalog")
    func trackingImageInitSuccess() throws {
        let name = "internal_img_1"
        let offset: SIMD3<Float> = .zero

        #expect(throws: Never.self) {
            let trackingImage = try TrackingImage(imageName: name, rootOffset: offset)
            #expect(trackingImage.imageName == name)
            #expect(trackingImage.rootOffset == offset)
        }
    }

    @Test("TrackingImage init throws imageNotFound when image is missing")
    func trackingImageInitThrowsForMissingImage() {
        let missingName = "DoesNotExist"
        let offset: SIMD3<Float> = .zero

        #expect(throws: TrackingError.self) {
            _ = try TrackingImage(imageName: missingName, rootOffset: offset)
        }
    }

}
