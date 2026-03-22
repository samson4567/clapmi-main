//
//  SocketConnection.swift
//  Broadcast Extension
//
//  Created by Alex-Dan Bumbu on 22/03/2021.
//  Copyright © 2021 Atlassian Inc. All rights reserved.
//

import Foundation
import OSLog

let broadcastLoggerSocket = OSLog(subsystem: "com.clapmi123.app", category: "Broadcast")

class SocketConnection: NSObject {
    var didOpen: (() -> Void)?
    var didClose: ((Error?) -> Void)?
    var streamHasSpaceAvailable: (() -> Void)?

    private let filePath: String
    private var socketHandle: Int32 = -1
    private var address: sockaddr_un?

    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    
    private var networkQueue: DispatchQueue?
    private var shouldKeepRunning = false

    init?(filePath path: String) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.init() - Creating with path: \(path)")
        os_log(.debug, log: broadcastLoggerSocket, "dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.init() - Creating with path: %{public}s", path)
        filePath = path
        socketHandle = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.init() - socketHandle: \(socketHandle)")
        os_log(.debug, log: broadcastLoggerSocket, "dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.init() - socketHandle: %d", socketHandle)

        guard socketHandle != -1 else {
            os_log(.debug, log: broadcastLoggerSocket, "failure: create socket")
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.init() - FAILED to create socket, returning nil")
            os_log(.debug, log: broadcastLoggerSocket, "dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.init() - FAILED to create socket, returning nil")
            return nil
        }
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.init() - Socket created successfully")
        os_log(.debug, log: broadcastLoggerSocket, "dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.init() - Socket created successfully")
    }

    func open() -> Bool {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - Attempting to open connection")
        os_log(.debug, log: broadcastLoggerSocket, "open socket connection")

        // Debug: List contents of the app group container
        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.clapmi123.app") {
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: containerURL, includingPropertiesForKeys: nil)
                print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - Container contents: \(contents.map { $0.lastPathComponent })")
                os_log(.debug, log: broadcastLoggerSocket, "dbjfkdbfskdfbkdbfkjbdsfkj Container contents: %{public}s", contents.map { $0.lastPathComponent }.joined(separator: ", "))
            } catch {
                print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - Error listing container: \(error)")
            }
        }

        guard FileManager.default.fileExists(atPath: filePath) else {
            os_log(.debug, log: broadcastLoggerSocket, "failure: socket file missing")
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - Socket file MISSING at path: \(filePath)")
            return false
        }
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - Socket file exists")
      
        guard setupAddress() == true else {
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - setupAddress() FAILED")
            return false
        }
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - setupAddress() succeeded")
        
        guard connectSocket() == true else {
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - connectSocket() FAILED")
            return false
        }
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - connectSocket() succeeded")

        setupStreams()
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - setupStreams() completed")
        
        inputStream?.open()
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - inputStream opened")
        outputStream?.open()
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - outputStream opened")

        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.open() - RETURNING TRUE - Connection opened successfully")
        return true
    }

    func close() {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.close() - Closing connection")
        unscheduleStreams()

        inputStream?.delegate = nil
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.close() - inputStream delegate set to nil")
        outputStream?.delegate = nil
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.close() - outputStream delegate set to nil")

        inputStream?.close()
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.close() - inputStream closed")
        outputStream?.close()
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.close() - outputStream closed")
        
        inputStream = nil
        outputStream = nil
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.close() - Streams set to nil")
    }

    func writeToStream(buffer: UnsafePointer<UInt8>, maxLength length: Int) -> Int {
        let result = outputStream?.write(buffer, maxLength: length) ?? 0
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.writeToStream() - wrote \(result) bytes (requested: \(length))")
        return result
    }
}

extension SocketConnection: StreamDelegate {

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.stream() - Event: \(eventCode), stream: \(aStream)")
        switch eventCode {
        case .openCompleted:
            os_log(.debug, log: broadcastLoggerSocket, "client stream open completed")
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.stream() - Stream open completed")
            if aStream == outputStream {
                print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.stream() - Calling didOpen callback")
                didOpen?()
            }
        case .hasBytesAvailable:
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.stream() - Has bytes available")
            if aStream == inputStream {
                var buffer: UInt8 = 0
                let numberOfBytesRead = inputStream?.read(&buffer, maxLength: 1)
                print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.stream() - Bytes read: \(String(describing: numberOfBytesRead))")
                if numberOfBytesRead == 0 && aStream.streamStatus == .atEnd {
                    os_log(.debug, log: broadcastLoggerSocket, "server socket closed")
                    print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.stream() - Server socket closed, calling close()")
                    close()
                    notifyDidClose(error: nil)
                }
            }
        case .hasSpaceAvailable:
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.stream() - Has space available")
            if aStream == outputStream {
                print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.stream() - Calling streamHasSpaceAvailable callback")
                streamHasSpaceAvailable?()
            }
        case .errorOccurred:
            os_log(.debug, log: broadcastLoggerSocket, "client stream error occurred: \(String(describing: aStream.streamError))")
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.stream() - ERROR OCCURRED: \(String(describing: aStream.streamError))")
            close()
            notifyDidClose(error: aStream.streamError)

        default:
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.stream() - Default case, event: \(eventCode)")
            break
        }
    }
}

private extension SocketConnection {
  
    func setupAddress() -> Bool {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.setupAddress() - Setting up address")
        var addr = sockaddr_un()
        guard filePath.count < MemoryLayout.size(ofValue: addr.sun_path) else {
            os_log(.debug, log: broadcastLoggerSocket, "failure: fd path is too long")
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.setupAddress() - FAILED: path too long")
            return false
        }

        _ = withUnsafeMutablePointer(to: &addr.sun_path.0) { ptr in
            filePath.withCString {
                strncpy(ptr, $0, filePath.count)
            }
        }
        
        address = addr
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.setupAddress() - Address setup complete, returning true")
        return true
    }

    func connectSocket() -> Bool {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.connectSocket() - Connecting socket")
        guard var addr = address else {
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.connectSocket() - FAILED: address is nil")
            return false
        }
        
        let status = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.connect(socketHandle, $0, socklen_t(MemoryLayout<sockaddr_un>.size))
            }
        }

        guard status == noErr else {
            os_log(.debug, log: broadcastLoggerSocket, "failure: \(status)")
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.connectSocket() - FAILED with status: \(status)")
            return false
        }
        
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.connectSocket() - Connection successful, returning true")
        return true
    }

    func setupStreams() {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.setupStreams() - Setting up streams")
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        CFStreamCreatePairWithSocket(kCFAllocatorDefault, socketHandle, &readStream, &writeStream)
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.setupStreams() - CFStream created")

        inputStream = readStream?.takeRetainedValue()
        inputStream?.delegate = self
        inputStream?.setProperty(kCFBooleanTrue, forKey: Stream.PropertyKey(kCFStreamPropertyShouldCloseNativeSocket as String))
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.setupStreams() - inputStream configured")

        outputStream = writeStream?.takeRetainedValue()
        outputStream?.delegate = self
        outputStream?.setProperty(kCFBooleanTrue, forKey: Stream.PropertyKey(kCFStreamPropertyShouldCloseNativeSocket as String))
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.setupStreams() - outputStream configured")

        scheduleStreams()
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.setupStreams() - scheduleStreams() called")
    }
  
    func scheduleStreams() {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.scheduleStreams() - Scheduling streams")
        shouldKeepRunning = true
        
        networkQueue = DispatchQueue.global(qos: .userInitiated)
        networkQueue?.async { [weak self] in
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.scheduleStreams() - Running in networkQueue")
            self?.inputStream?.schedule(in: .current, forMode: .common)
            self?.outputStream?.schedule(in: .current, forMode: .common)
            RunLoop.current.run()
            
            var isRunning = false
                        
            repeat {
                isRunning = self?.shouldKeepRunning ?? false && RunLoop.current.run(mode: .default, before: .distantFuture)
            } while (isRunning)
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.scheduleStreams() - RunLoop ended")
        }
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.scheduleStreams() - Queue started")
    }
    
    func unscheduleStreams() {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.unscheduleStreams() - Unscheduling streams")
        networkQueue?.sync { [weak self] in
            self?.inputStream?.remove(from: .current, forMode: .common)
            self?.outputStream?.remove(from: .current, forMode: .common)
        }
        
        shouldKeepRunning = false
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.unscheduleStreams() - shouldKeepRunning set to false")
    }
    
    func notifyDidClose(error: Error?) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.notifyDidClose() - error: \(String(describing: error))")
        if didClose != nil {
            print("dbjfkdbfskdfbkdbfkjbdsfkj SocketConnection.notifyDidClose() - Calling didClose callback")
            didClose?(error)
        }
    }
}