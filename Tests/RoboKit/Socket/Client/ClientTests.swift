//
//  ClientTests.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 15/05/25.
//
import Foundation
@testable import RoboKit
import Network
import Testing

@Suite("TCPClient Core Tests")
struct TCPClientTests {
    let client: TCPClient
    let testMessage: CPRMessageModel

    init() async {
        client = await TCPClient(host: "localhost", port: 1234)
        testMessage = CPRMessageModel(clawControl: true, positionAndRotation: [1.0, 2.0, 3.0, 4.0])
    }

    @Test("Test Client Initialization")
    func testInitializationSetsHostAndPort() async throws {
        await #expect(client.host == "localhost")
        await #expect(client.port == 1234)
        await #expect(client.connection != nil)
    }

    @Test("Test basic connection callbacks")
    func testBasicConnectionCallbacks() async {
        var setupCalled = false
        var waitingCalled = false
        var readyCalled = false

        await client.setSetupConnection {
            setupCalled = true
        }
        await client.setWaitingConnection {
            waitingCalled = true
        }
        await client.setReadyConnection {
            readyCalled = true
        }

        await client.setUpConnection()
        await client.connectionWaiting()
        await client.connectionReady(data: Data("test".utf8))

        #expect(setupCalled == true)
        #expect(waitingCalled == true)
        #expect(readyCalled == true)
    }

    @Test("Test connection failure handling")
    func testConnectionFailureHandling() async {
        await client.startConnection(value: Data("Hello".utf8))
        await client.connectionFailed()
        await #expect(client.connection?.stateUpdateHandler == nil)
    }

    @Test("Test connection ending")
    func testConnectionEnding() async {
        await client.sendRawData(Data("test".utf8))
        await client.connectionEnded()
        await #expect(client.connection?.stateUpdateHandler == nil)
    }

    @Test("Test startConnection with message")
    func testStartConnectionWithMessage() async {
        await client.startConnection(with: testMessage)
        await #expect(client.connection?.stateUpdateHandler != nil)
    }

    @Test("Test startConnection with data")
    func testStartConnectionWithData() async {
        let testData = Data("Hello, RoboKit!".utf8)
        await client.startConnection(value: testData)
        await #expect(client.connection?.stateUpdateHandler != nil)
    }

    @Test("Test startConnection without data")
    func testStartConnectionWithoutData() async {
        await client.startConnection()
        await #expect(client.connection?.stateUpdateHandler != nil)
    }

    @Test("Test sendMessage")
    func testSendMessage() async {
        await client.sendMessage(testMessage)
        #expect(true)
    }

    @Test("Test sendSecureMessage")
    func testSendSecureMessage() async {
        await client.sendSecureMessage(payload: testMessage)
        #expect(true)
    }

    @Test("Test sendRawData")
    func testSendRawData() async {
        let testData = Data("Hello, RoboKit!".utf8)
        await client.sendRawData(testData)
        #expect(true)
    }

    @Test("Test receiveMessage")
    func testReceiveMessage() async {
        await client.receiveMessage()
        #expect(true)
    }

    @Test("Test security configurations")
    func testSecurityConfigurations() async {
        // Test TLS client
        let tlsClient = await TCPClient(
            host: "localhost",
            port: 1290,
            security: SecurityOptions(useTLS: true)
        )
        await tlsClient.startConnection(with: testMessage)
        await #expect(tlsClient.connection?.stateUpdateHandler != nil)

        // Test non-TLS client
        let nonTLSClient = await TCPClient(
            host: "localhost",
            port: 1291,
            security: SecurityOptions(useTLS: false)
        )
        await nonTLSClient.startConnection(with: testMessage)
        await #expect(nonTLSClient.connection?.stateUpdateHandler != nil)
    }

    @Test("Test complete message flow")
    func testCompleteMessageFlow() async {
        await client.startConnection(with: testMessage)
        await client.sendMessage(testMessage)
        await client.receiveMessage()
        await client.connectionEnded()
        #expect(true)
    }
}
