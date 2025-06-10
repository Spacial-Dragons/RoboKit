import Testing
import Foundation
@testable import RoboKit

struct Message: Codable, Equatable {
    var text: String
    var id: Int
}

@Suite("JSON Tests")
struct JSONTests {
    let message = Message(text: "Hello, RoboKit!", id: 2)
    let CPRMessage = CPRMessageModel(clawControl: true, positionAndRotation: [0, 0, 0, 0], objectWidth: 0)
    @Test("CPRMessage Object is encoded to JSON") func encodingCPRMessageObjectToJSONTest() async throws {
        let data = CodingManager.encodeToJSON(data: CPRMessage)
        let decoded = try CodingManager.decodeFromJSON(data: data) as CPRMessageModel
        #expect(decoded == CPRMessage)
    }
    @Test("CPRMessage Object is decoded from JSON") func decodingCPRMessageObjectFromJSONTest() async throws {
        let json = Data("""
    {
        "clawControl": true,
        "positionAndRotation": [0, 0, 0],
        "objectWidth": 0
    }
    """.utf8)
        let decoded = try CodingManager.decodeFromJSON(data: json) as CPRMessageModel
        #expect(decoded.clawControl == true)
        #expect(decoded.positionAndRotation == [0, 0, 0])
        #expect(decoded.objectWidth == 0)
    }
    @Test("Object is encoded to JSON") func encodingObjectToJSONTest() async throws {
        let data = CodingManager.encodeToJSON(data: message)
        let decoded = try CodingManager.decodeFromJSON(data: data) as Message
        #expect(decoded == message)
    }
    @Test("Object is decoded from JSON") func decodingObjectFromJSONTest() async throws {
        let json = Data("""
    {
        "text": "Hello",
        "id": 1
    }
    """.utf8)
        let decoded = try CodingManager.decodeFromJSON(data: json) as Message
        #expect(decoded.id == 1)
        #expect(decoded.text == "Hello")
    }
}
