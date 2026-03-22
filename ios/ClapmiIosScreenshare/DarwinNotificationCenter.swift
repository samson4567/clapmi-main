//
//  DarwinNotificationCenter.swift
//  Broadcast Extension
//
//  Created by Alex-Dan Bumbu on 23/03/2021.
//  Copyright © 2021 8x8, Inc. All rights reserved.
//

import Foundation
import OSLog

let broadcastLoggerDarwin = OSLog(subsystem: "com.clapmi123.app", category: "Broadcast")

enum DarwinNotification: String {
    case broadcastStarted = "iOS_BroadcastStarted"
    case broadcastStopped = "iOS_BroadcastStopped"
}

class DarwinNotificationCenter {
    
    static let shared = DarwinNotificationCenter()
    
    private let notificationCenter: CFNotificationCenter
    
    init() {
        print("dbjfkdbfskdfbkdbfkjbdsfkj DarwinNotificationCenter.init() - Creating DarwinNotificationCenter")
        notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        print("dbjfkdbfskdfbkdbfkjbdsfkj DarwinNotificationCenter.init() - notificationCenter created")
    }
    
    func postNotification(_ name: DarwinNotification) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj DarwinNotificationCenter.postNotification() - Posting: \(name.rawValue)")
        CFNotificationCenterPostNotification(notificationCenter, CFNotificationName(rawValue: name.rawValue as CFString), nil, nil, true)
        print("dbjfkdbfskdfbkdbfkjbdsfkj DarwinNotificationCenter.postNotification() - Notification posted successfully")
    }
}