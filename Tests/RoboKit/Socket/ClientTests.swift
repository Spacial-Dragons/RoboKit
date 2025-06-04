//
//  ClienTests.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 15/05/25.
//
import Foundation
@testable import RoboKit
import Network
import Testing

@Suite("TCPClient Tests")
struct TCPClientTests {
    let client: TCPClient
    init() async {
        client = await TCPClient(host: "localhost", port: 1234)
    }
    @Test("Test Client Initiliazation") func testInitializationSetsHostAndPort() async throws {
        await #expect(client.host == "localhost")
        await #expect(client.port == 1234)
        await #expect(client.connection != nil)
    }

    @Test("Test if the SetUp Connection closure is being called")
    func testSetupConnectionCallbackIsCalled() async throws {
        var test: String?
        await client.setSetupConnection {
            test = "Closure Called"
        }
        await client.setUpConnection()
        #expect(test == "Closure Called")
    }

    @Test("Test if the Waiting Connection closure is being called")
    func testWaitingConnectionCallbackIsCalled() async {
        var test: String?
        await client.setWaitingConnection {
            test = "Closure Called"
        }
        await client.connectionWaiting()
        #expect(test == "Closure Called")
    }
    @Test("Test if the Preparing Connection closure is being called")
    func testPreparingConnectionCallbackIsCalled() async {
        var test: String?
        await client.setPreparingConnection {
            test = "Closure Called"
        }
        await client.connectionPreparing()
        #expect(test == "Closure Called")
    }
    @Test("Test if the Preparing Connection closure is being called")
    func testReadyConnectionCallbackIsCalled() async {
        var test: String?
        await client.setReadyConnection {
            test = "Closure Called"
        }
        await client.connectionReady(value: Data("test".utf8))
        #expect(test == "Closure Called")
    }
    @Test("Test if the Cancelled Connection closure is being called")
    func testCancelledConnectionCallbackIsCalled() async {
        var test: String?
        await client.setCancelledConnection {
            test = "Closure Called"
        }
        await client.connectionCanceled()
        #expect(test == "Closure Called")
    }
    @Test("Test if the Failed Connection is cancelling the connection when it fails")
    func testConnectionFailedCancelsConnection() async {
        await client.startConnection(value: Data("Hello".utf8))
        await client.connectionFailed()
        await #expect(client.connection?.stateUpdateHandler == nil)
    }
    @Test("Test if the Ended Connection function is properly canceling the connection")
    func testConnectionEndedCancelsConnection() async {
            await client.sendMessage(data: Data("test".utf8))
            await client.connectionEnded()
            await #expect(client.connection?.stateUpdateHandler == nil)
    }
}
