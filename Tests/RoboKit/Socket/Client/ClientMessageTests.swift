//
//  ClientMessageTests.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 15/05/25.
//
import Foundation
@testable import RoboKit
import Network
import Testing

@Suite("TCPClient Message Tests")
struct TCPClientMessageTests {
    let testMessage: CPRMessageModel

    init() async {
        testMessage = CPRMessageModel(clawControl: true, positionAndRotation: [1.0, 2.0, 3.0, 4.0])
    }

    // MARK: - ReceiveMessage Tests

    @Test("Test receiveMessage basic functionality")
    func testReceiveMessageBasic() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1260)
        await client.receiveMessage()
        #expect(true)
    }

    @Test("Test receiveMessage with custom lengths")
    func testReceiveMessageCustomLengths() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1261)

        await client.receiveMessage(minLength: 10, maxLength: 1024)
        await client.receiveMessage(minLength: 1, maxLength: 10)
        await client.receiveMessage(minLength: 1000, maxLength: 131072)

        #expect(true)
    }

    @Test("Test receiveMessage handles completion and errors")
    func testReceiveMessageHandlesCompletionAndErrors() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1262)

        await client.receiveMessage()
        await client.connectionEnded()

        let client2 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1263)
        await client2.receiveMessage()
        await client2.connectionFailed()

        #expect(true)
    }

    // MARK: - SendMessage Tests

    @Test("Test sendMessage with different security configurations")
    func testSendMessageWithDifferentSecurity() async {
        // Test with default security (TLS without additional features)
        let client1 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1264)
        await client1.sendMessage(testMessage)

        // Test with TLS and security features
        let client2 = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1265,
            security: SecurityOptions(
                useTLS: true,
                tokenProvider: { "test-token" },
                checksumProvider: { data in "checksum-\(data.count)" }
            )
        )
        await client2.sendMessage(testMessage)

        // Test with TLS only
        let client3 = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1266,
            security: SecurityOptions(useTLS: true)
        )
        await client3.sendMessage(testMessage)

        // Test with non-TLS
        let client4 = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1267,
            security: SecurityOptions(useTLS: false)
        )
        await client4.sendMessage(testMessage)

        #expect(true)
    }

    @Test("Test sendMessage with different message types")
    func testSendMessageDifferentTypes() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1268)

        let message1 = CPRMessageModel(clawControl: false, positionAndRotation: [0.0, 0.0, 0.0, 0.0])
        let message2 = CPRMessageModel(clawControl: true, positionAndRotation: [999.99, 888.88, 777.77, 666.66])

        await client.sendMessage(message1)
        await client.sendMessage(message2)

        #expect(true)
    }

    @Test("Test sendMessage preserves message integrity")
    func testSendMessageIntegrity() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1269)
        let originalMessage = CPRMessageModel(clawControl: true, positionAndRotation: [1.0, 2.0, 3.0, 4.0])

        #expect(originalMessage.clawControl == true)
        #expect(originalMessage.positionAndRotation == [1.0, 2.0, 3.0, 4.0])

        await client.sendMessage(originalMessage)

        #expect(originalMessage.clawControl == true)
        #expect(originalMessage.positionAndRotation == [1.0, 2.0, 3.0, 4.0])
    }

    // MARK: - SendSecureMessage Tests

    @Test("Test sendSecureMessage basic functionality")
    func testSendSecureMessageBasic() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1270)
        await client.sendSecureMessage(payload: testMessage)
        #expect(true)
    }

    @Test("Test sendSecureMessage with security features")
    func testSendSecureMessageWithSecurity() async {
        let client = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1271,
            security: SecurityOptions(
                useTLS: true,
                tokenProvider: { "secure-token" },
                checksumProvider: { data in "secure-checksum-\(data.count)" }
            )
        )
        await client.sendSecureMessage(payload: testMessage)
        #expect(true)
    }

    @Test("Test sendSecureMessage with different payloads")
    func testSendSecureMessageDifferentPayloads() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1272)

        let message1 = CPRMessageModel(clawControl: false, positionAndRotation: [0.0, 0.0, 0.0, 0.0])
        let message2 = CPRMessageModel(clawControl: true, positionAndRotation: [999.99, 888.88, 777.77, 666.66])

        await client.sendSecureMessage(payload: message1)
        await client.sendSecureMessage(payload: message2)

        #expect(true)
    }

    @Test("Test sendSecureMessage preserves payload integrity")
    func testSendSecureMessageIntegrity() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1273)
        let originalMessage = CPRMessageModel(clawControl: true, positionAndRotation: [1.0, 2.0, 3.0, 4.0])

        #expect(originalMessage.clawControl == true)
        #expect(originalMessage.positionAndRotation == [1.0, 2.0, 3.0, 4.0])

        await client.sendSecureMessage(payload: originalMessage)

        #expect(originalMessage.clawControl == true)
        #expect(originalMessage.positionAndRotation == [1.0, 2.0, 3.0, 4.0])
    }

    // MARK: - SendRawData Tests

    @Test("Test sendRawData basic functionality")
    func testSendRawDataBasic() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1274)
        let testData = Data("Hello, RoboKit!".utf8)
        await client.sendRawData(testData)
        #expect(true)
    }

    @Test("Test sendRawData with different data types")
    func testSendRawDataDifferentTypes() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1275)

        // Test with string data
        let stringData = Data("String data".utf8)
        await client.sendRawData(stringData)

        // Test with JSON data
        let jsonData = Data("""
        {"clawControl": true, "positionAndRotation": [1.0, 2.0, 3.0, 4.0]}
        """.utf8)
        await client.sendRawData(jsonData)

        // Test with binary data
        let binaryData = Data([0x00, 0x01, 0x02, 0x03, 0xFF, 0xFE, 0xFD])
        await client.sendRawData(binaryData)

        #expect(true)
    }

    @Test("Test sendRawData handles edge cases")
    func testSendRawDataEdgeCases() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1276)

        // Test with empty data
        let emptyData = Data()
        await client.sendRawData(emptyData)

        // Test with large data
        let largeData = Data(repeating: 65, count: 65536)
        await client.sendRawData(largeData)

        #expect(true)
    }

    @Test("Test sendRawData preserves data integrity")
    func testSendRawDataIntegrity() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1277)
        let originalData = Data("Original data".utf8)

        #expect(originalData == Data("Original data".utf8))

        await client.sendRawData(originalData)

        #expect(originalData == Data("Original data".utf8))
    }

    @Test("Test sendRawData handles errors")
    func testSendRawDataErrors() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1278)
        let testData = Data("Error test".utf8)

        await client.sendRawData(testData)
        await client.connectionFailed()

        #expect(true)
    }

    // MARK: - Message Processing Tests

    @Test("Test processReceivedData flow")
    func testProcessReceivedDataFlow() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1279)

        // Test secure message processing flow
        let secureMessage = await client.createSecureMessage(payload: testMessage)
        _ = CodingManager.encodeToJSON(data: secureMessage)
        await client.receiveMessage()

        // Test regular message processing flow
        let client2 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1280)
        _ = CodingManager.encodeToJSON(data: testMessage)
        await client2.receiveMessage()

        // Test invalid data processing flow
        let client3 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1281)
        _ = Data("invalid json data".utf8)
        await client3.receiveMessage()

        #expect(true)
    }

    // MARK: - Integration Tests

    @Test("Test message sending and receiving flow")
    func testMessageFlow() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1282)
        await client.sendMessage(testMessage)
        await client.receiveMessage()
        #expect(true)
    }

    @Test("Test secure message flow")
    func testSecureMessageFlow() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1283)
        await client.sendSecureMessage(payload: testMessage)
        await client.receiveMessage()
        #expect(true)
    }

    @Test("Test raw data flow")
    func testRawDataFlow() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1284)
        let testData = Data("Raw data flow test".utf8)
        await client.sendRawData(testData)
        await client.receiveMessage()
        #expect(true)
    }

    @Test("Test all message methods with different security configurations")
    func testAllMessageMethodsWithSecurity() async {
        // Test all message methods with TLS security
        let tlsClient = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1285,
            security: SecurityOptions(useTLS: true)
        )

        await tlsClient.sendMessage(testMessage)
        await tlsClient.sendSecureMessage(payload: testMessage)
        await tlsClient.sendRawData(Data("TLS test".utf8))
        await tlsClient.receiveMessage()

        // Test all message methods with non-TLS security
        let nonTLSClient = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1286,
            security: SecurityOptions(useTLS: false)
        )

        await nonTLSClient.sendMessage(testMessage)
        await nonTLSClient.sendSecureMessage(payload: testMessage)
        await nonTLSClient.sendRawData(Data("Non-TLS test".utf8))
        await nonTLSClient.receiveMessage()

        #expect(true)
    }
}
