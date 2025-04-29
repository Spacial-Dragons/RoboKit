import Testing
@testable import RoboKit

@MainActor
@Suite("Tracking Image")
struct TrackingImageTests {

    @Test("TrackingImage init succeeds when image exists in asset catalog")
    func trackingImageInitSuccess() throws {
        let name = "img_1"
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
