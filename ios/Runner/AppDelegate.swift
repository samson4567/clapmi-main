import UIKit
import Flutter
import flutter_local_notifications
import ReplayKit
import FirebaseCore
import FirebaseMessaging
import AVFoundation
import OSLog

let appDelegateLogger = OSLog(subsystem: "com.clapmi123.app", category: "AppDelegate")

@main
@objc class AppDelegate: FlutterAppDelegate {

    private var screenCaptureChannel: FlutterMethodChannel?
    private var isRecording = false

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // This is required to make any communication available in the action isolate.
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }

        // Setup Firebase Messaging for iOS
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // Register for remote notifications
        application.registerForRemoteNotifications()

        // Setup screen capture MethodChannel
        setupScreenCaptureChannel()

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Handle device token for Firebase Cloud Messaging
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.didRegisterForRemoteNotificationsWithDeviceToken() - Device Token: \(token)")
        
        // Pass token to Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
    }

    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.didFailToRegisterForRemoteNotificationsWithError() - Failed: \(error.localizedDescription)")
    }

    private func setupScreenCaptureChannel() {
        os_log(.debug, log: appDelegateLogger, "dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - Setting up screen capture channel")
        print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - Setting up screen capture channel")
        
        // Debug: Check if Info.plist has the RTCScreenSharingExtension key
        if let extBundleID = Bundle.main.object(forInfoDictionaryKey: "RTCScreenSharingExtension") as? String {
            os_log(.debug, log: appDelegateLogger, "dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - RTCScreenSharingExtension from Info.plist: %{public}@", extBundleID)
            print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - RTCScreenSharingExtension from Info.plist: \(extBundleID)")
        } else {
            os_log(.debug, log: appDelegateLogger, "dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - WARNING: RTCScreenSharingExtension NOT found in Info.plist")
            print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - WARNING: RTCScreenSharingExtension NOT found in Info.plist")
        }
        
        if let appGroupID = Bundle.main.object(forInfoDictionaryKey: "RTCAppGroupIdentifier") as? String {
            os_log(.debug, log: appDelegateLogger, "dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - RTCAppGroupIdentifier from Info.plist: %{public}@", appGroupID)
            print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - RTCAppGroupIdentifier from Info.plist: \(appGroupID)")
        } else {
            os_log(.debug, log: appDelegateLogger, "dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - WARNING: RTCAppGroupIdentifier NOT found in Info.plist")
            print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - WARNING: RTCAppGroupIdentifier NOT found in Info.plist")
        }
        
        guard let controller = window?.rootViewController as? FlutterViewController else {
            print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - FAILED: controller is nil")
            return
        }
        print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - controller found")

        screenCaptureChannel = FlutterMethodChannel(
            name: "com.clapmi.mvp/screen_capture",
            binaryMessenger: controller.binaryMessenger
        )
        print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - channel created: com.clapmi.mvp/screen_capture")

        screenCaptureChannel?.setMethodCallHandler { [weak self] (call, result) in
            print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - Method call received: \(call.method)")
            switch call.method {
            case "startScreenCapture":
                print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - startScreenCapture called")
                self?.handleStartScreenCapture(call: call, result: result)

            case "stopScreenCapture":
                print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - stopScreenCapture called")
                self?.handleStopScreenCapture(result: result)

            case "showBroadcastPicker":
                print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - showBroadcastPicker called")
                self?.handleShowBroadcastPicker(result: result)

            case "isServiceRunning":
                print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - isServiceRunning called")
                // Check if screen recording is active by checking UserDefaults from extension
                let defaults = UserDefaults(suiteName: "group.com.clapmi123.app")
                let started = defaults?.bool(forKey: "extensionStarted") ?? false
                let startTime = defaults?.string(forKey: "extensionStartTime") ?? "nil"
                print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - extensionStarted: \(started), startTime: \(startTime)")
                result(self?.isRecording ?? started)

            default:
                print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - Unknown method: \(call.method)")
                result(FlutterMethodNotImplemented)
            }
        }
        print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.setupScreenCaptureChannel() - Method handler set")
    }

    // MARK: - Screen Capture Handlers

    private func handleStartScreenCapture(call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleStartScreenCapture() - Starting RPScreenRecorder capture")
        guard !RPScreenRecorder.shared().isRecording else {
            print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleStartScreenCapture() - Already recording, returning true")
            result(true)
            return
        }
        RPScreenRecorder.shared().startCapture(
            handler: { sampleBuffer, bufferType, error in
                if let error = error {
                    print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleStartScreenCapture() - Capture error: \(error)")
                }
                // Handle sample buffer here (e.g. stream via WebRTC, write to file, etc.)
            },
            completionHandler: { [weak self] error in
                if let error = error {
                    print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleStartScreenCapture() - Failed to start: \(error)")
                    result(false)
                } else {
                    print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleStartScreenCapture() - Started successfully")
                    self?.isRecording = true
                    result(true)
                }
            }
        )
    }

    private func handleStopScreenCapture(result: @escaping FlutterResult) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleStopScreenCapture() - Stopping RPScreenRecorder capture")
        RPScreenRecorder.shared().stopCapture { [weak self] error in
            self?.isRecording = false
            if let error = error {
                print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleStopScreenCapture() - Stop error: \(error)")
            } else {
                print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleStopScreenCapture() - Stopped successfully")
            }
            result(nil)
        }
    }

    private func handleShowBroadcastPicker(result: @escaping FlutterResult) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleShowBroadcastPicker() - Showing broadcast picker")

        if #available(iOS 12.0, *) {
            guard let window = self.window else {
                print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleShowBroadcastPicker() - Window is nil")
                result(false)
                return
            }

            // Debug: Check what's in the app group container before showing picker
            if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.clapmi123.app") {
                do {
                    let contents = try FileManager.default.contentsOfDirectory(at: containerURL, includingPropertiesForKeys: nil)
                    print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleShowBroadcastPicker() - Container BEFORE picker: \(contents.map { $0.lastPathComponent })")
                } catch {
                    print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleShowBroadcastPicker() - Error listing container: \(error)")
                }
            }

            // Create picker - keep it visible but use system default UI
            let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            picker.preferredExtension = "com.clapmi123.app.ClapmiIosScreenshare"
            picker.showsMicrophoneButton = false
            
            // FIX: Make picker visible on iOS 17+ for reliable touch handling
            // The picker should be visible to receive touches properly
            if #available(iOS 17.0, *) {
                picker.isHidden = false
            } else {
                picker.isHidden = true
            }
            
            window.addSubview(picker)

            DispatchQueue.main.async {
                // Trigger the picker button tap
                if let button = picker.subviews.first as? UIButton {
                    button.sendActions(for: .touchUpInside)
                    print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleShowBroadcastPicker() - Picker triggered via button")
                } else {
                    // Fallback: try to trigger all buttons
                    for subview in picker.subviews {
                        if let button = subview as? UIButton {
                            button.sendActions(for: .touchUpInside)
                        }
                    }
                    print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleShowBroadcastPicker() - Picker triggered via fallback")
                }
                
                // Remove picker after a delay to allow system picker to appear
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    picker.removeFromSuperview()
                    print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleShowBroadcastPicker() - Picker removed from superview")
                }
            }

            result(true)
        } else {
            print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.handleShowBroadcastPicker() - iOS < 12 not supported")
            result(FlutterError(
                code: "UNSUPPORTED_IOS_VERSION",
                message: "Broadcast picker requires iOS 12.0 or later",
                details: nil
            ))
        }
    }
}

func registerPlugins(registry: FlutterPluginRegistry) {
    GeneratedPluginRegistrant.register(with: registry)
}

// Firebase Messaging Delegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj AppDelegate.messaging() - Firebase registration token: \(fcmToken ?? "nil")")
    }
}