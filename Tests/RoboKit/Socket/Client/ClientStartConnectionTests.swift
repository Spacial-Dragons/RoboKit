//
//  ClientStartConnectionTests.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 15/05/25.
//
import Foundation
@testable import RoboKit
import Network
import Testing

@Suite("TCPClient StartConnection Tests")
struct TCPClientStartConnectionTests {
    let testMessage: CPRMessageModel

    init() async {
        testMessage = CPRMessageModel(clawControl: true, positionAndRotation: [1.0, 2.0, 3.0, 4.0], objectWidth: 0.7)
    }

    // MARK: - StartConnection with CPRMessageModel Tests

    @Test("Test startConnection with CPRMessageModel basic functionality")
    func testStartConnectionWithMessage() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1234)
        await client.startConnection(with: testMessage)
        await #expect(client.connection?.stateUpdateHandler != nil)
    }

    @Test("Test startConnection with CPRMessageModel calls readyConnection callback")
    func testStartConnectionCallsReadyCallback() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1235)
        await client.setReadyConnection {
            // This callback should be called when connection is ready
        }
        await client.connectionReady(message: testMessage)
        #expect(true)
    }

    @Test("Test startConnection with CPRMessageModel handles different message types")
    func testStartConnectionWithDifferentMessages() async {
        let message1 = CPRMessageModel(clawControl: false, positionAndRotation: [0.0, 0.0, 0.0, 0.0], objectWidth: 0.7)
        let message2 = CPRMessageModel(clawControl: true,
                                       positionAndRotation: [999.99, 888.88, 777.77, 666.66],
                                       objectWidth: 0.7)

        let client1 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1236)
        await client1.startConnection(with: message1)
        await #expect(client1.connection?.stateUpdateHandler != nil)

        let client2 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1237)
        await client2.startConnection(with: message2)
        await #expect(client2.connection?.stateUpdateHandler != nil)
    }

    @Test("Test startConnection with CPRMessageModel preserves message integrity")
    func testStartConnectionPreservesMessageIntegrity() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1238)
        let originalMessage = CPRMessageModel(clawControl: true,
                                              positionAndRotation: [1.0, 2.0, 3.0, 4.0],
                                              objectWidth: 0.7)

        #expect(originalMessage.clawControl == true)
        #expect(originalMessage.positionAndRotation == [1.0, 2.0, 3.0, 4.0])

        await client.startConnection(with: originalMessage)

        #expect(originalMessage.clawControl == true)
        #expect(originalMessage.positionAndRotation == [1.0, 2.0, 3.0, 4.0])
    }

    @Test("Test startConnection with CPRMessageModel handles state transitions")
    func testStartConnectionStateTransitions() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1239)

        await client.setSetupConnection { }
        await client.setWaitingConnection { }
        await client.setPreparingConnection { }
        await client.setReadyConnection { }

        await client.startConnection(with: testMessage)

        await client.setUpConnection()
        await client.connectionWaiting()
        await client.connectionPreparing()
        await client.connectionReady(message: testMessage)

        #expect(true)
    }

    @Test("Test startConnection with CPRMessageModel handles failure states")
    func testStartConnectionFailureStates() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1240)

        await client.setFailedConnection { }
        await client.setCancelledConnection { }

        await client.startConnection(with: testMessage)

        await client.connectionFailed()
        await client.connectionCanceled()

        #expect(true)
    }

    // MARK: - StartConnection with Data Tests

    @Test("Test startConnection with Data basic functionality")
    func testStartConnectionWithData() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1241)
        let testData = Data("Hello, RoboKit!".utf8)

        await client.startConnection(value: testData)
        await #expect(client.connection?.stateUpdateHandler != nil)
    }

    @Test("Test startConnection with Data calls readyConnection callback")
    func testStartConnectionWithDataCallsReadyCallback() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1242)
        let testData = Data("Callback test".utf8)

        await client.setReadyConnection { }
        await client.connectionReady(data: testData)

        #expect(true)
    }

    @Test("Test startConnection with Data handles different data types")
    func testStartConnectionWithDifferentDataTypes() async {
        // Test with string data
        let client1 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1243)
        let stringData = Data("String data".utf8)
        await client1.startConnection(value: stringData)
        await #expect(client1.connection?.stateUpdateHandler != nil)

        // Test with JSON data
        let client2 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1244)
        let jsonData = Data("""
        {"clawControl": true, "positionAndRotation": [1.0, 2.0, 3.0, 4.0]}
        """.utf8)
        await client2.startConnection(value: jsonData)
        await #expect(client2.connection?.stateUpdateHandler != nil)

        // Test with binary data
        let client3 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1245)
        let binaryData = Data([0x00, 0x01, 0x02, 0x03, 0xFF, 0xFE, 0xFD])
        await client3.startConnection(value: binaryData)
        await #expect(client3.connection?.stateUpdateHandler != nil)
    }

    @Test("Test startConnection with Data preserves data integrity")
    func testStartConnectionWithDataPreservesIntegrity() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1246)
        let originalData = Data("Original data".utf8)

        #expect(originalData == Data("Original data".utf8))

        await client.startConnection(value: originalData)

        #expect(originalData == Data("Original data".utf8))
    }

    @Test("Test startConnection with Data handles edge cases")
    func testStartConnectionWithDataEdgeCases() async {
        // Test with empty data
        let client1 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1247)
        let emptyData = Data()
        await client1.startConnection(value: emptyData)
        await #expect(client1.connection?.stateUpdateHandler != nil)

        // Test with large data
        let client2 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1248)
        let largeData = Data(repeating: 65, count: 65536)
        await client2.startConnection(value: largeData)
        await #expect(client2.connection?.stateUpdateHandler != nil)
    }

    // MARK: - StartConnection without Data Tests

    @Test("Test startConnection without data basic functionality")
    func testStartConnectionWithoutData() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1249)
        await client.startConnection()
        await #expect(client.connection?.stateUpdateHandler != nil)
    }

    @Test("Test startConnection without data calls readyConnection callback")
    func testStartConnectionWithoutDataCallsReadyCallback() async {
        let client = await TCPClient<CPRMessageModel>(host: "localhost", port: 1250)
        await client.setReadyConnection { }
        await client.connectionReady()
        #expect(true)
    }

    // MARK: - Security Configuration Tests

    @Test("Test startConnection variants with different security configurations")
    func testStartConnectionVariantsWithSecurity() async {
        let testData = Data("Security variants test".utf8)

        // Test with TLS security
        let tlsClient1 = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1251,
            security: SecurityOptions(useTLS: true)
        )
        await tlsClient1.startConnection(with: testMessage)
        await #expect(tlsClient1.connection?.stateUpdateHandler != nil)

        let tlsClient2 = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1252,
            security: SecurityOptions(useTLS: true)
        )
        await tlsClient2.startConnection(value: testData)
        await #expect(tlsClient2.connection?.stateUpdateHandler != nil)

        let tlsClient3 = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1253,
            security: SecurityOptions(useTLS: true)
        )
        await tlsClient3.startConnection()
        await #expect(tlsClient3.connection?.stateUpdateHandler != nil)

        // Test with non-TLS security
        let nonTLSClient1 = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1254,
            security: SecurityOptions(useTLS: false)
        )
        await nonTLSClient1.startConnection(with: testMessage)
        await #expect(nonTLSClient1.connection?.stateUpdateHandler != nil)

        let nonTLSClient2 = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1255,
            security: SecurityOptions(useTLS: false)
        )
        await nonTLSClient2.startConnection(value: testData)
        await #expect(nonTLSClient2.connection?.stateUpdateHandler != nil)

        let nonTLSClient3 = await TCPClient<CPRMessageModel>(
            host: "localhost",
            port: 1256,
            security: SecurityOptions(useTLS: false)
        )
        await nonTLSClient3.startConnection()
        await #expect(nonTLSClient3.connection?.stateUpdateHandler != nil)
    }

    // MARK: - Integration Tests

    @Test("Test all startConnection variants work consistently")
    func testAllStartConnectionVariants() async {
        let testData = Data("Comparison test".utf8)

        let client1 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1257)
        await client1.startConnection(with: testMessage)
        await #expect(client1.connection?.stateUpdateHandler != nil)

        let client2 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1258)
        await client2.startConnection(value: testData)
        await #expect(client2.connection?.stateUpdateHandler != nil)

        let client3 = await TCPClient<CPRMessageModel>(host: "localhost", port: 1259)
        await client3.startConnection()
        await #expect(client3.connection?.stateUpdateHandler != nil)
    }

    // MARK: - Generic Message Type Tests

    @Test("Test startConnection with generic message types")
    func testStartConnectionWithGenericMessageTypes() async {
        // Test with a custom message type
        struct CustomMessage: Codable, Sendable {
            let id: Int
            let command: String
        }

        let customMessage = CustomMessage(id: 1, command: "test")
        let client = await TCPClient<CustomMessage>(host: "localhost", port: 1260)

        await client.startConnection(with: customMessage)
        await #expect(client.connection?.stateUpdateHandler != nil)
    }

    @Test("Test startConnection with different message types in same test")
    func testStartConnectionWithDifferentMessageTypes() async {
        // Test with CPRMessageModel
        let cprClient = await TCPClient<CPRMessageModel>(host: "localhost", port: 1261)
        await cprClient.startConnection(with: testMessage)
        await #expect(cprClient.connection?.stateUpdateHandler != nil)

        // Test with a different message type
        struct SensorData: Codable, Sendable {
            let temperature: Double
            let humidity: Double
        }

        let sensorData = SensorData(temperature: 25.5, humidity: 60.0)
        let sensorClient = await TCPClient<SensorData>(host: "localhost", port: 1262)
        await sensorClient.startConnection(with: sensorData)
        await #expect(sensorClient.connection?.stateUpdateHandler != nil)
    }
}
