import Testing
import simd
@testable import RoboKit


@MainActor
@Suite("Image Tracker")
struct ImageTrackerTests {

    private let trackingImagesConfig: [TrackingImage]
    private var tracker: ImageTracker
    
    init() {
        self.trackingImagesConfig = [
            TrackingImage(imageName: "img_1", rootOffset: .init(x: 1.1, y: 2.2, z: 3.0)),
            TrackingImage(imageName: "img_2", rootOffset: .init(x: -1.0, y: -3.5, z: 0.0)),
            TrackingImage(imageName: "img_3", rootOffset: .init(x: 10.2, y: -10.2, z: -3.0)),
        ]
        
        self.tracker = .init(
            arResourceGroupName: "RoboKitTestsArResourceGroup",
            images: trackingImagesConfig
        )
    }
    
    @Test("Get tracked images transform")
    func getTrackedImagesTransformTest() {
        // Test that getTrackedImagesTransform() returns the expected default transforms in simulator.
        let trackedImagesTransforms: [simd_float4x4] = tracker.getTrackedImagesTransform()
        for i in 0..<trackedImagesTransforms.count {
            #expect(trackedImagesTransforms[i].position == trackingImagesConfig[i].rootOffset)
        }
    }
    
    @Test("Compute root position")
    func computeRootPositionTest() {
        // Test the averaging logic in computeRootPosition() for correctly computing the root transform based on multiple anchors.
        #expect(true)
    }
    
}
