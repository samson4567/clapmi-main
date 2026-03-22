//
//  SampleUploader.swift
//  Broadcast Extension
//
//  Created by Alex-Dan Bumbu on 22/03/2021.
//  Copyright © 2021 8x8, Inc. All rights reserved.
//

import Foundation
import ReplayKit
import OSLog

let broadcastLogger2 = OSLog(subsystem: "com.clapmi123.app", category: "Broadcast")

private enum Constants {
    static let bufferMaxLength = 10240
}

class SampleUploader {
    
    private static var imageContext = CIContext(options: nil)
    
    @Atomic private var isReady = false
    private var connection: SocketConnection
  
    private var dataToSend: Data?
    private var byteIndex = 0
  
    private let serialQueue: DispatchQueue
    
    init(connection: SocketConnection) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.init() - Creating SampleUploader with connection")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.init() - Creating SampleUploader with connection")
        self.connection = connection
        self.serialQueue = DispatchQueue(label: "org.jitsi.meet.broadcast.sampleUploader")
      
        setupConnection()
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.init() - setupConnection() completed")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.init() - setupConnection() completed")
    }
  
    @discardableResult func send(sample buffer: CMSampleBuffer) -> Bool {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - isReady: \(isReady)")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - isReady: %d", isReady)
        guard isReady else {
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - NOT READY, returning false")
            os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - NOT READY, returning false")
            return false
        }
        
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - isReady is TRUE, proceeding")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - isReady is TRUE, proceeding")
        isReady = false
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - isReady set to false")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - isReady set to false")

        dataToSend = prepare(sample: buffer)
        byteIndex = 0
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - data prepared, byteIndex reset to 0")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - data prepared, byteIndex reset to 0")

        serialQueue.async { [weak self] in
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - async sendDataChunk() called")
            os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.send() - async sendDataChunk() called")
            self?.sendDataChunk()
        }
        
        return true
    }
}

private extension SampleUploader {
    
    func setupConnection() {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - Setting up connection callbacks")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - Setting up connection callbacks")
        connection.didOpen = { [weak self] in
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - didOpen callback triggered")
            os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - didOpen callback triggered")
            self?.isReady = true
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - isReady set to TRUE")
            os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - isReady set to true")
        }
        connection.streamHasSpaceAvailable = { [weak self] in
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - streamHasSpaceAvailable callback triggered")
            os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - streamHasSpaceAvailable callback triggered")
            self?.serialQueue.async {
                if let success = self?.sendDataChunk() {
                    print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - sendDataChunk() returned: \(success)")
                    os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - sendDataChunk() returned: %d", success)
                    self?.isReady = !success
                    print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - isReady set to: \(!success)")
                    os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - isReady set to: %d", !success)
                }
            }
        }
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - Callbacks configured")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.setupConnection() - Callbacks configured")
    }
    
    @discardableResult func sendDataChunk() -> Bool {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - called")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - called")
        guard let dataToSend = dataToSend else {
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - dataToSend is nil, returning false")
            os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - dataToSend is nil, returning false")
            return false
        }
      
        var bytesLeft = dataToSend.count - byteIndex
        var length = bytesLeft > Constants.bufferMaxLength ? Constants.bufferMaxLength : bytesLeft
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - bytesLeft: \(bytesLeft), length: \(length)")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - bytesLeft: %d, length: %d", bytesLeft, length)

        length = dataToSend[byteIndex..<(byteIndex + length)].withUnsafeBytes {
            guard let ptr = $0.bindMemory(to: UInt8.self).baseAddress else {
                print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - ptr is nil, returning 0")
                os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - ptr is nil, returning 0")
                return 0
            }

            return connection.writeToStream(buffer: ptr, maxLength: length)
        }

        if length > 0 {
            byteIndex += length
            bytesLeft -= length
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - Written \(length) bytes, bytesLeft: \(bytesLeft)")
            os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - Written %d bytes, bytesLeft: %d", length, bytesLeft)

            if bytesLeft == 0 {
                self.dataToSend = nil
                byteIndex = 0
                print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - All data sent, clearing dataToSend")
                os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - All data sent, clearing dataToSend")
            }
        } else {
            os_log(.debug, log: broadcastLogger2, "writeBufferToStream failure")
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - writeBufferToStream failure!")
            os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.sendDataChunk() - writeBufferToStream failure!")
        }
      
        return true
    }
    
    func prepare(sample buffer: CMSampleBuffer) -> Data? {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - Preparing sample buffer")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - Preparing sample buffer")
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            os_log(.debug, log: broadcastLogger2, "image buffer not available")
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - image buffer NOT available, returning nil")
            os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - image buffer NOT available, returning nil")
            return nil
        }
        
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - Image buffer available, locking")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - Image buffer available, locking")
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        
        let scaleFactor = 1.0
        let width = CVPixelBufferGetWidth(imageBuffer)/Int(scaleFactor)
        let height = CVPixelBufferGetHeight(imageBuffer)/Int(scaleFactor)
        let orientation = CMGetAttachment(buffer, key: RPVideoSampleOrientationKey as CFString, attachmentModeOut: nil)?.uintValue ?? 0
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - width: \(width), height: \(height), orientation: \(orientation)")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - width: %d, height: %d, orientation: %d", width, height, orientation)
                                    
        let scaleTransform = CGAffineTransform(scaleX: CGFloat(1.0/scaleFactor), y: CGFloat(1.0/scaleFactor))
        let bufferData = self.jpegData(from: imageBuffer, scale: scaleTransform)
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - jpegData created")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - jpegData created")
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - Pixel buffer unlocked")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - Pixel buffer unlocked")
        
        guard let messageData = bufferData else {
            os_log(.debug, log: broadcastLogger2, "corrupted image buffer")
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - jpegData is nil, returning nil")
            os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - jpegData is nil, returning nil")
            return nil
        }
              
        let httpResponse = CFHTTPMessageCreateResponse(nil, 200, nil, kCFHTTPVersion1_1).takeRetainedValue()
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Content-Length" as CFString, String(messageData.count) as CFString)
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Buffer-Width" as CFString, String(width) as CFString)
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Buffer-Height" as CFString, String(height) as CFString)
        CFHTTPMessageSetHeaderFieldValue(httpResponse, "Buffer-Orientation" as CFString, String(orientation) as CFString)
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - HTTP headers set")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - HTTP headers set")
        
        CFHTTPMessageSetBody(httpResponse, messageData as CFData)
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - HTTP body set")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - HTTP body set")
        
        let serializedMessage = CFHTTPMessageCopySerializedMessage(httpResponse)?.takeRetainedValue() as Data?
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - Message serialized, returning data")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.prepare() - Message serialized, returning data")
      
        return serializedMessage
    }
    
    func jpegData(from buffer: CVPixelBuffer, scale scaleTransform: CGAffineTransform) -> Data? {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.jpegData() - Creating JPEG from CVPixelBuffer")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.jpegData() - Creating JPEG from CVPixelBuffer")
        let image = CIImage(cvPixelBuffer: buffer).transformed(by: scaleTransform)
        
        guard let colorSpace = image.colorSpace else {
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.jpegData() - colorSpace is nil, returning nil")
            os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.jpegData() - colorSpace is nil, returning nil")
            return nil
        }
      
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.jpegData() - colorSpace available")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.jpegData() - colorSpace available")
        let options: [CIImageRepresentationOption: Float] = [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: 1.0]

        let result = SampleUploader.imageContext.jpegRepresentation(of: image, colorSpace: colorSpace, options: options)
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.jpegData() - JPEG representation created: \(result != nil)")
        os_log(.debug, log: broadcastLogger2, "dbjfkdbfskdfbkdbfkjbdsfkj SampleUploader.jpegData() - JPEG representation created: %d", result != nil)
        return result
    }
}