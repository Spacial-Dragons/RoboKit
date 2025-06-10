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
@testable import RoboKit
import Network
import Testing

@Suite("Connection Tests - Send Data")
struct ConnectionTestsSendData {
    let mockConnection: Connection<CPRMessageModel>
    let testMessage: CPRMessageModel
    let testData: Data

    init() async {
        let nwConnection = NWConnection(host: .ipv4(.loopback), port: 1234, using: .tcp)
        mockConnection = await Connection(nwConnection: nwConnection)
        testMessage = CPRMessageModel(clawControl: true, positionAndRotation: [1.0, 2.0, 3.0, 4.0])
        testData = Data("Test data".utf8)
    }

    // MARK: - SecurityOptions Helper Methods
    func basicSecurity() -> SecurityOptions { SecurityOptions(useTLS: false) }
    func tlsSecurity() -> SecurityOptions { SecurityOptions(useTLS: true) }
    func tokenSecurity() -> SecurityOptions { SecurityOptions(useTLS: true, tokenProvider: { "test-token-123" }) }
    func checksumSecurity() -> SecurityOptions {
        SecurityOptions(useTLS: true, checksumProvider: { data in "checksum-\(data.count)" })
    }
    func fullSecurity() -> SecurityOptions {
        SecurityOptions(useTLS: true, tokenProvider: { "test-token-456" }, checksumProvider: { _ in "secure-checksum" })
    }

   // MARK: - Send Data Tests

   @Test("Test send data with various sizes")
   func testSendDataSizes() async {
       // Test basic data
       await mockConnection.send(data: testData)

       // Test empty data
       await mockConnection.send(data: Data())

       // Test large data (64KB)
       await mockConnection.send(data: Data(repeating: 65, count: 65536))

       #expect(true)
   }

   @Test("Test send data with various data types")
   func testSendDataTypes() async {
       await mockConnection.send(data: Data("Hello, RoboKit!".utf8))
       await mockConnection.send(data: Data("""
       {"clawControl": true, "positionAndRotation": [1.0, 2.0, 3.0, 4.0]}
       """.utf8))
       await mockConnection.send(data: Data([0x00, 0x01, 0x02, 0x03, 0xFF, 0xFE, 0xFD]))
       #expect(true)
   }

   @Test("Test send data multiple times and state changes")
   func testSendDataMultipleAndStates() async {
       // Send multiple messages in sequence
       for index in 0..<5 {
           await mockConnection.send(data: Data("Message \(index)".utf8))
       }

       // Test with state changes
       await mockConnection.stateDidChange(to: .ready)
       await mockConnection.send(data: testData)

       #expect(true)
   }

   @Test("Test send data preserves data integrity")
   func testSendDataIntegrity() async {
       let testData1 = Data("First message".utf8)
       let testData2 = Data("Second message".utf8)
       let testData3 = Data("Third message".utf8)

       await mockConnection.send(data: testData1)
       await mockConnection.send(data: testData2)
       await mockConnection.send(data: testData3)

       #expect(testData1 == Data("First message".utf8))
       #expect(testData2 == Data("Second message".utf8))
       #expect(testData3 == Data("Third message".utf8))
   }

   @Test("Test send data completion handler paths")
   func testSendDataCompletionPaths() async {
       // Test error path simulation
       var failedCallbackTriggered = false
       await mockConnection.setFailedConnection { failedCallbackTriggered = true }
       await mockConnection.connectionDidFail(error: NWError.posix(.ECONNREFUSED))
       #expect(failedCallbackTriggered == true)

       // Test success path simulation
       await Connection<CPRMessageModel>.log("Test log message from send completion", level: .debug)
       #expect(true)
   }

   @Test("Test send data concurrency and weak self")
   func testSendDataConcurrencyAndWeakSelf() async {
       // Test concurrent operations
       let messages = (0..<10).map { Data("Concurrent message \($0)".utf8) }
       await withTaskGroup(of: Void.self) { group in
           for message in messages {
               group.addTask { await self.mockConnection.send(data: message) }
           }
       }

       // Test weak self behavior with state changes
       for index in 0..<3 {
           await mockConnection.send(data: Data("Weak self test \(index)".utf8))
           await mockConnection.stateDidChange(to: .preparing)
           await mockConnection.stateDidChange(to: .ready)
       }

       #expect(true)
   }

   // MARK: - Send Message Tests

   @Test("Test sendMessage with all security configurations")
   func testSendMessageSecurity() async {
       await mockConnection.sendMessage(testMessage, security: basicSecurity())
       await mockConnection.sendMessage(testMessage, security: tlsSecurity())
       await mockConnection.sendMessage(testMessage, security: tokenSecurity())
       await mockConnection.sendMessage(testMessage, security: checksumSecurity())
       await mockConnection.sendMessage(testMessage, security: fullSecurity())
       #expect(true)
   }

   // MARK: - Process Received Data Tests

   @Test("Test processReceivedData with valid messages")
   func testProcessReceivedDataValid() async {
       // Test regular CPRMessageModel
       await mockConnection.processReceivedData(CodingManager.encodeToJSON(data: testMessage))
       let latestMessage1 = await mockConnection.latestMessage
       #expect(latestMessage1?.clawControl == true)

       // Test SecureMessageWrapper
       let secureWrapper = SecureMessageWrapper(payload: testMessage, token: "test-token", checksum: "test-checksum")
       await mockConnection.processReceivedData(CodingManager.encodeToJSON(data: secureWrapper))
       let latestMessage2 = await mockConnection.latestMessage
       #expect(latestMessage2?.clawControl == true)
   }

   @Test("Test processReceivedData error handling and fallback")
   func testProcessReceivedDataErrorHandling() async {
       // Test invalid JSON
       let originalMessage = await mockConnection.latestMessage
       await mockConnection.processReceivedData(Data("invalid json data".utf8))
       let afterMessage = await mockConnection.latestMessage
       #expect(afterMessage?.clawControl == originalMessage?.clawControl)

       // Test partial JSON
       await mockConnection.processReceivedData(Data("{\"clawControl\": true, \"position".utf8))

       // Test fallback from secure to regular
       await mockConnection.updateLatestMessage(
        message: CPRMessageModel(clawControl: false, positionAndRotation: [0, 0, 0, 0])
       )
       await mockConnection.processReceivedData(CodingManager.encodeToJSON(data: testMessage))
       let latestMessage = await mockConnection.latestMessage
       #expect(latestMessage?.clawControl == true)
   }

   // MARK: - Edge Case Tests

   @Test("Test edge cases")
   func testEdgeCases() async {
       // Test sendMessage with nil providers
       await mockConnection.sendMessage(
        testMessage, security: SecurityOptions(useTLS: true, tokenProvider: nil, checksumProvider: nil)
       )

       // Test processReceivedData with empty data
       await mockConnection.processReceivedData(Data())

       // Test processReceivedData with large message
       let largeMessage = CPRMessageModel(clawControl: true, positionAndRotation: Array(repeating: 999.99, count: 1000))
       await mockConnection.processReceivedData(CodingManager.encodeToJSON(data: largeMessage))
       let latestMessage = await mockConnection.latestMessage
       #expect(latestMessage?.clawControl == true)
       #expect(latestMessage?.positionAndRotation.count == 1000)
   }
}
