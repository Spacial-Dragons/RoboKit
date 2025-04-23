import Testing
@testable import RoboKit

@Test func example() async throws {
    let anchor1 = RoboKit.AnchorData(transform: .init(), imageName: "Test 1")
    let anchor2 = RoboKit.AnchorData(transform: .init(), imageName: "Test 2")
    #expect(anchor1 == anchor2)
}
