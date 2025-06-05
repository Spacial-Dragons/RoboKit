//
//  ServerTests.swift
//  RoboKit
//
//  Created by Sofia Diniz Melo Santos on 28/05/25.
//
//
import Foundation
@testable import RoboKit
import Network
import Testing

@Suite("Connection Tests")
struct ConnectionTests {
    let mockConnection: Connection

    init() async {
        let nwConnection = NWConnection(host: .ipv4(.loopback), port: 1234, using: .tcp)
        mockConnection = await Connection(nwConnection: nwConnection)
    }

    @Test("Test setupConnection closure is called")
    func testSetupConnectionCallback() async {
        var flag = false
        await mockConnection.setSetupConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .setup)
        #expect(flag == true)
    }

    @Test("Test waitingConnection closure is called")
    func testWaitingConnectionCallback() async {
        var flag = false
        await mockConnection.setWaitingConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .waiting(NWError.posix(.ECONNREFUSED)))
        #expect(flag == true)
    }

    @Test("Test preparingConnection closure is called")
    func testPreparingConnectionCallback() async {
        var flag = false
        await mockConnection.setPreparingConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .preparing)
        #expect(flag == true)
    }

    @Test("Test readyConnection closure is called")
    func testReadyConnectionCallback() async {
        var flag = false
        await mockConnection.setReadyConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .ready)
        #expect(flag == true)
    }

    @Test("Test cancelledConnection closure is called")
    func testCancelledConnectionCallback() async {
        var flag = false
        await mockConnection.setCancelledConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .cancelled)
        #expect(flag == true)
    }

    @Test("Test failedConnection closure is called")
    func testFailedConnectionCallback() async {
        var flag = false
        await mockConnection.setFailedConnection {
            flag = true
        }
        await mockConnection.stateDidChange(to: .failed(NWError.posix(.ETIMEDOUT)))
        #expect(flag == true)
    }
}
