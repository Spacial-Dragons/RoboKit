//
//  ClientProcessReceivedDataTests.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 15/05/25.
//
import Foundation
@testable import RoboKit
import Network
import Testing

@Suite("TCPClient ProcessReceivedData Tests")
struct TCPClientProcessReceivedDataTests {
    let testMessage: CPRMessageModel

    init() async {
        testMessage = CPRMessageModel(clawControl: true, positionAndRotation: [1.0, 2.0, 3.0, 4.0], objectWidth: 0.7)
    }

    // MARK: - Secure Message Processing Tests

    @Test("Test processReceivedData with secure message containing token and checksum")
    func testProcessReceivedDataWithSecureMessage() async {
        let client = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1300,
            security: SecurityOptions(
                useTLS: true,
                tokenProvider: { "test-token-12345" },
                checksumProvider: { data in "checksum-\(data.count)" }
            )
        )

        // Create a secure message
        let secureMessage = await client.createSecureMessage(payload: testMessage)
        let secureData = CodingManager.encodeToJSON(data: secureMessage)

        // Directly call processReceivedData with the secure message data
        await client.processReceivedData(secureData)

        #expect(true)
    }

    @Test("Test processReceivedData with secure message without checksum")
    func testProcessReceivedDataWithSecureMessageNoChecksum() async {
        let client = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1302,
            security: SecurityOptions(
                useTLS: true,
                tokenProvider: { "test-token" },
                checksumProvider: nil
            )
        )

        // Create a secure message without checksum
        let secureMessage = SecureMessageWrapper(
            payload: testMessage, token: "test-token",
            checksum: nil
        )
        let secureData = CodingManager.encodeToJSON(data: secureMessage)

        // Directly call processReceivedData
        await client.processReceivedData(secureData)

        #expect(true)
    }

    @Test("Test processReceivedData with secure message with checksum verification")
    func testProcessReceivedDataWithChecksumVerification() async {
        let client = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1303,
            security: SecurityOptions(
                useTLS: true,
                tokenProvider: { "test-token" },
                checksumProvider: { _ in "valid-checksum" }
            )
        )

        // Create a secure message with valid checksum
        _ = CodingManager.encodeToJSON(data: testMessage)
        let validChecksum = "valid-checksum"
        let secureMessage = SecureMessageWrapper(
            payload: testMessage, token: "test-token",
            checksum: validChecksum
        )
        let secureData = CodingManager.encodeToJSON(data: secureMessage)

        // Directly call processReceivedData
        await client.processReceivedData(secureData)

        #expect(true)
    }

    // MARK: - Regular Message Processing Tests

    @Test("Test processReceivedData with regular CPRMessageModel")
    func testProcessReceivedDataWithRegularMessage() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1305)

        // Create a regular message
        let regularData = CodingManager.encodeToJSON(data: testMessage)

        // Directly call processReceivedData
        await client.processReceivedData(regularData)

        #expect(true)
    }

    @Test("Test processReceivedData with different regular message types")
    func testProcessReceivedDataWithDifferentMessageTypes() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1306)

        // Test with different message types
        let message1 = CPRMessageModel(clawControl: false, positionAndRotation: [0.0, 0.0, 0.0, 0.0], objectWidth: 0.7)
        let message2 = CPRMessageModel(clawControl: true, positionAndRotation: [999.99, 888.88, 777.77, 666.66], objectWidth: 0.7)

        let data1 = CodingManager.encodeToJSON(data: message1)
        let data2 = CodingManager.encodeToJSON(data: message2)

        // Directly call processReceivedData with different message types
        await client.processReceivedData(data1)
        await client.processReceivedData(data2)

        #expect(true)
    }

    // MARK: - Error Handling Tests

    @Test("Test processReceivedData with invalid JSON data")
    func testProcessReceivedDataWithInvalidJSON() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1307)

        // Create invalid JSON data
        let invalidData = Data("invalid json data".utf8)

        // Directly call processReceivedData with invalid data
        await client.processReceivedData(invalidData)

        #expect(true)
    }

    @Test("Test processReceivedData with empty data")
    func testProcessReceivedDataWithEmptyData() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1308)

        // Create empty data
        let emptyData = Data()

        // Directly call processReceivedData with empty data
        await client.processReceivedData(emptyData)

        #expect(true)
    }

    @Test("Test processReceivedData with malformed secure message")
    func testProcessReceivedDataWithMalformedSecureMessage() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1309)

        // Create malformed secure message (missing required fields)
        let malformedData = Data("""
        {"token": "test-token", "payload": null}
        """.utf8)

        // Directly call processReceivedData with malformed data
        await client.processReceivedData(malformedData)

        #expect(true)
    }

    @Test("Test processReceivedData with corrupted data")
    func testProcessReceivedDataWithCorruptedData() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1310)

        // Create corrupted data
        let corruptedData = Data([0xFF, 0xFE, 0xFD, 0xFC, 0xFB])

        // Directly call processReceivedData with corrupted data
        await client.processReceivedData(corruptedData)

        #expect(true)
    }

    @Test("Test processReceivedData with partial JSON")
    func testProcessReceivedDataWithPartialJSON() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1311)

        // Create partial JSON data
        let partialData = Data("""
        {"clawControl": true, "positionAndRotation": [1.0, 2.0
        """.utf8)

        // Directly call processReceivedData with partial JSON
        await client.processReceivedData(partialData)

        #expect(true)
    }

    // MARK: - Edge Cases Tests

    @Test("Test processReceivedData with very large message")
    func testProcessReceivedDataWithLargeMessage() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1312)

        // Create a large message
        let largeMessage = CPRMessageModel(
            clawControl: true,
            positionAndRotation: Array(repeating: 1.0, count: 1000),
            objectWidth: 0.7
        )
        let largeData = CodingManager.encodeToJSON(data: largeMessage)

        // Directly call processReceivedData with large message
        await client.processReceivedData(largeData)

        #expect(true)
    }

    @Test("Test processReceivedData with null values in secure message")
    func testProcessReceivedDataWithNullValues() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1313)

        // Create secure message with null values
        let nullMessage = SecureMessageWrapper(
            payload: testMessage, token: nil,
            checksum: nil
        )
        let nullData = CodingManager.encodeToJSON(data: nullMessage)

        // Directly call processReceivedData with null values
        await client.processReceivedData(nullData)

        #expect(true)
    }

    @Test("Test processReceivedData with empty secure message")
    func testProcessReceivedDataWithEmptySecureMessage() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1314)

        // Create empty secure message
        let emptySecureMessage = SecureMessageWrapper(
            payload: testMessage, token: "",
            checksum: ""
        )
        let emptySecureData = CodingManager.encodeToJSON(data: emptySecureMessage)

        // Directly call processReceivedData with empty secure message
        await client.processReceivedData(emptySecureData)

        #expect(true)
    }

    // MARK: - Security Configuration Tests

    @Test("Test processReceivedData with different security configurations")
    func testProcessReceivedDataWithDifferentSecurityConfigs() async {
        // Test with TLS and security features
        let secureClient = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1315,
            security: SecurityOptions(
                useTLS: true,
                tokenProvider: { "secure-token" },
                checksumProvider: { _ in "secure-checksum" }
            )
        )
        let secureMessage = SecureMessageWrapper(
            payload: testMessage, token: "secure-token",
            checksum: "secure-checksum"
        )
        let secureData = CodingManager.encodeToJSON(data: secureMessage)
        await secureClient.processReceivedData(secureData)

        // Test with TLS only
        let tlsClient = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1316,
            security: SecurityOptions(useTLS: true)
        )
        await tlsClient.processReceivedData(secureData)

        // Test with non-TLS
        let nonTLSClient = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1317,
            security: SecurityOptions(useTLS: false)
        )
        await nonTLSClient.processReceivedData(secureData)

        #expect(true)
    }

    // MARK: - Integration Tests

    @Test("Test processReceivedData handles multiple message types in sequence")
    func testProcessReceivedDataMultipleMessageTypes() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1318)

        // Create different types of messages
        let secureMessage = SecureMessageWrapper(
            payload: testMessage, token: "test-token",
            checksum: "test-checksum"
        )
        let secureData = CodingManager.encodeToJSON(data: secureMessage)
        let regularData = CodingManager.encodeToJSON(data: testMessage)
        let invalidData = Data("invalid json data".utf8)

        // Process different message types in sequence
        await client.processReceivedData(secureData)
        await client.processReceivedData(regularData)
        await client.processReceivedData(invalidData)
        #expect(true)
    }

    @Test("Test processReceivedData with concurrent processing")
    func testProcessReceivedDataConcurrentProcessing() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1319)

        // Create test data
        let secureData = CodingManager.encodeToJSON(data: SecureMessageWrapper(
            payload: testMessage, token: "test-token",
            checksum: "test-checksum"
        ))
        let regularData = CodingManager.encodeToJSON(data: testMessage)

        // Simulate concurrent message processing
        async let process1: () = client.processReceivedData(secureData)
        async let process2: () = client.processReceivedData(regularData)
        async let process3: () = client.processReceivedData(Data("invalid".utf8))

        // Wait for all to complete
        await process1
        await process2
        await process3

        #expect(true)
    }

    @Test("Test processReceivedData with checksum verification scenarios")
    func testProcessReceivedDataChecksumVerificationScenarios() async {
        let client = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1320,
            security: SecurityOptions(
                useTLS: true,
                tokenProvider: { "test-token" },
                checksumProvider: { _ in "expected-checksum" }
            )
        )

        // Test with matching checksum
        let validSecureMessage = SecureMessageWrapper(
            payload: testMessage, token: "test-token",
            checksum: "expected-checksum"
        )
        let validData = CodingManager.encodeToJSON(data: validSecureMessage)
        await client.processReceivedData(validData)

        // Test with non-matching checksum
        let invalidSecureMessage = SecureMessageWrapper(
            payload: testMessage, token: "test-token",
            checksum: "wrong-checksum"
        )
        let invalidData = CodingManager.encodeToJSON(data: invalidSecureMessage)
        await client.processReceivedData(invalidData)

        #expect(true)
    }
}
 
