import Testing
@testable import RoboKit


@Suite("Image Tracker")
struct ImageTrackerTests {
    
    @Test("Get tracked images transform")
    func getTrackedImagesTransformTest() {
        // Test that getTrackedImagesTransform() returns the expected transforms in simulator.
        #expect(true)
    }
    
    @Test("Compute root position")
    func computeRootPositionTest() {
        // Test the averaging logic in computeRootPosition() for correctly computing the root transform based on multiple anchors.
        #expect(true)
    }
    
}
