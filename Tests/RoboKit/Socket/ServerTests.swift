//
//  ServerTests.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 03/06/25.
//
import Foundation
import Testing
@testable import RoboKit
import Network

@Suite("TCPServer Tests")
struct TCPServerTests {
    let server: TCPServer
    let connection: Connection
    init() async throws {
        self.connection = await Connection(nwConnection: NWConnection(host: .ipv4(.loopback), port: 1234, using: .tcp))
        do {
            self.server = try await TCPServer(port: 1234)
        } catch {
            throw TestError.serverNotInitialized
        }
    }
    @Test("Test server initializes and starts")
    func testServerStart() async throws {
        try await server.start(logMessage: "Testing")
        await #expect(server.listener.stateUpdateHandler != nil)
        await #expect(server.listener.newConnectionHandler != nil)
    }

    @Test("Test didAccept adds connection to dictionary")
    func testDidAcceptAddsConnection() async throws {
        await server.didAccept(nwConnection: connection)
        let storedConnection = await server.connectionsByID[connection.id]
        #expect(storedConnection === connection)
    }

    @Test("Test connectionDidStop removes connection")
    func testConnectionDidStopRemovesConnection() async throws {
        await server.didAccept(nwConnection: connection)
        await server.connectionDidStop(connection)
        let storedConnection = await server.connectionsByID[connection.id]
        #expect(storedConnection == nil)
    }

    @Test("Test stop cancels all connections and listener")
    func testStopShutsDownServer() async throws {
        await server.didAccept(nwConnection: connection)
        await server.stop()
        #expect((await server.connectionsByID).isEmpty)
    }
}

enum TestError: Error {
    case serverNotInitialized
}
