//
//  SampleHandler.swift
//  Broadcast Extension
//
//  Created by Alex-Dan Bumbu on 04.06.2021.
//

import ReplayKit
import OSLog

let broadcastLogger = OSLog(subsystem: "com.clapmi123.app", category: "Broadcast")
private enum Constants {
    // the App Group ID value that the app and the broadcast extension targets are setup with. It differs for each app.
    static let appGroupIdentifier = "group.com.clapmi123.app"
}

class SampleHandler: RPBroadcastSampleHandler {

    private var clientConnection: SocketConnection?
    private var uploader: SampleUploader?

    private var frameCount: Int = 0

    var socketFilePath: String {
      let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupIdentifier)
        return sharedContainer?.appendingPathComponent("rtc_SSFD").path ?? ""
    }

    override init() {
        print("dbjfkdbfskdfbkdbfkjbdsfkj-fdbjsfbksdjf SampleHandler.init() - Starting initialization")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj-fdbjsfbksdjf SampleHandler.init() - Starting initialization")
      super.init()
        
        // Write to shared container to verify extension was initialized
        let defaults = UserDefaults(suiteName: Constants.appGroupIdentifier)
        defaults?.set(true, forKey: "extensionInitialized")
        defaults?.set(Date().description, forKey: "extensionInitTime")
        defaults?.synchronize()
        
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - Wrote extensionInitialized=true to UserDefaults")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - Wrote extensionInitialized=true to UserDefaults")
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - Starting initialization")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - Starting initialization")
        if let connection = SocketConnection(filePath: socketFilePath) {
          print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - SocketConnection created successfully")
          os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - SocketConnection created successfully")
          clientConnection = connection
          setupConnection()
          print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - Connection setup complete")
          os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - Connection setup complete")

          uploader = SampleUploader(connection: connection)
          print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - SampleUploader created")
          os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - SampleUploader created")
        } else {
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - SocketConnection creation FAILED")
            os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - SocketConnection creation FAILED")
        }
        os_log(.debug, log: broadcastLogger, "%{public}s", socketFilePath)
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - socketFilePath: \(socketFilePath)")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.init() - socketFilePath: %{public}s", socketFilePath)
    }

    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        
        // Write to shared container to verify extension was launched
        let defaults = UserDefaults(suiteName: Constants.appGroupIdentifier)
        defaults?.set(true, forKey: "extensionStarted")
        defaults?.set(Date().description, forKey: "extensionStartTime")
        defaults?.synchronize()
        
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - Wrote extensionStarted=true to UserDefaults")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - Wrote extensionStarted=true to UserDefaults")
        
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - BROADCAST STARTED with setupInfo: \(String(describing: setupInfo))")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - BROADCAST STARTED")
        frameCount = 0
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - frameCount reset to 0")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - frameCount reset to 0")

        // Debug: Check app group container contents
        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupIdentifier) {
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: containerURL, includingPropertiesForKeys: nil)
                print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - Container contents: \(contents.map { $0.lastPathComponent })")
            } catch {
                print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - Error listing container: \(error)")
            }
        }

        DarwinNotificationCenter.shared.postNotification(.broadcastStarted)
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - Darwin notification posted: broadcastStarted")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - Darwin notification posted: broadcastStarted")
        openConnection()
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - openConnection() called")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastStarted() - openConnection() called")
    }

    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastPaused() - BROADCAST PAUSED")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastPaused() - BROADCAST PAUSED")
    }

    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastResumed() - BROADCAST RESUMED")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastResumed() - BROADCAST RESUMED")
    }

    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastFinished() - BROADCAST FINISHED")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastFinished() - BROADCAST FINISHED")
        DarwinNotificationCenter.shared.postNotification(.broadcastStopped)
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastFinished() - Darwin notification posted: broadcastStopped")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastFinished() - Darwin notification posted: broadcastStopped")
        clientConnection?.close()
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastFinished() - clientConnection closed")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.broadcastFinished() - clientConnection closed")
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.processSampleBuffer() - Processing sample buffer type: \(sampleBufferType)")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.processSampleBuffer() - type: %d", sampleBufferType.rawValue)
        switch sampleBufferType {
        case RPSampleBufferType.video:
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.processSampleBuffer() - Calling uploader.send() for video")
            os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.processSampleBuffer() - Calling uploader.send() for video")
            uploader?.send(sample: sampleBuffer)
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.processSampleBuffer() - uploader.send() completed")
            os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.processSampleBuffer() - uploader.send() completed")
        default:
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.processSampleBuffer() - Ignoring non-video buffer type")
            os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.processSampleBuffer() - Ignoring non-video buffer type")
            break
        }
    }
}

private extension SampleHandler {

    func setupConnection() {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.setupConnection() - Setting up connection callbacks")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.setupConnection() - Setting up connection callbacks")
        clientConnection?.didClose = { [weak self] error in
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.setupConnection() - didClose callback triggered with error: \(String(describing: error))")
            os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.setupConnection() - didClose callback triggered with error: %{public}s", String(describing: error))

            if let error = error {
                self?.finishBroadcastWithError(error)
            } else {
                // the displayed failure message is more user friendly when using NSError instead of Error
                let JMScreenSharingStopped = 10001
                let customError = NSError(domain: RPRecordingErrorDomain, code: JMScreenSharingStopped, userInfo: [NSLocalizedDescriptionKey: "Screen sharing stopped"])
                self?.finishBroadcastWithError(customError)
            }
        }
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.setupConnection() - didClose callback set")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.setupConnection() - didClose callback set")
    }

    func openConnection() {
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.openConnection() - Opening connection with timer")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.openConnection() - Opening connection with timer")
        
        // Debug: Check if socket file exists before trying to connect
        let socketExists = FileManager.default.fileExists(atPath: socketFilePath)
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.openConnection() - Socket file exists before connect: \(socketExists)")
        
        let queue = DispatchQueue(label: "broadcast.connectTimer")
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: .milliseconds(100), leeway: .milliseconds(500))
        timer.setEventHandler { [weak self] in
            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.openConnection() - Timer event fired")
            os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.openConnection() - Timer event fired")
            guard self?.clientConnection?.open() == true else {
                print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.openConnection() - clientConnection.open() returned false")
                os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.openConnection() - clientConnection.open() returned false")
                return
            }

            print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.openConnection() - clientConnection.open() returned true, cancelling timer")
            os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.openConnection() - clientConnection.open() returned true, cancelling timer")
            timer.cancel()
        }

        timer.resume()
        print("dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.openConnection() - Timer started")
        os_log(.debug, log: broadcastLogger, "dbjfkdbfskdfbkdbfkjbdsfkj SampleHandler.openConnection() - Timer started")
    }
}