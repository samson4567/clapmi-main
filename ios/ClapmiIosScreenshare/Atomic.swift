//
//  Atomic.swift
//  Broadcast Extension
//
//  Created by Maksym Shcheglov.
//  https://www.onswiftwings.com/posts/atomic-property-wrapper/
//

import Foundation
import OSLog

let broadcastLoggerAtomic = OSLog(subsystem: "com.clapmi123.app", category: "Broadcast")

@propertyWrapper
struct Atomic<Value> {

    private var value: Value
    private let lock = NSLock()

    init(wrappedValue value: Value) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj Atomic.init() - Creating Atomic with value: \(String(describing: value))")
        self.value = value
    }

    var wrappedValue: Value {
        get { 
            let result = load()
            print("dbjfkdbfskdfbkdbfkjbdsfkj Atomic.wrappedValue.get - loaded value: \(String(describing: result))")
            return result 
        }
        set { 
            print("dbjfkdbfskdfbkdbfkjbdsfkj Atomic.wrappedValue.set - newValue: \(String(describing: newValue))")
            store(newValue: newValue) 
        }
    }

    func load() -> Value {
        print("dbjfkdbfskdfbkdbfkjbdsfkj Atomic.load() - Acquiring lock")
        lock.lock()
        defer { lock.unlock() }
        print("dbjfkdbfskdfbkdbfkjbdsfkj Atomic.load() - Returning value: \(String(describing: value))")
        return value
    }

    mutating func store(newValue: Value) {
        print("dbjfkdbfskdfbkdbfkjbdsfkj Atomic.store() - Acquiring lock for newValue: \(String(describing: newValue))")
        lock.lock()
        defer { lock.unlock() }
        value = newValue
        print("dbjfkdbfskdfbkdbfkjbdsfkj Atomic.store() - Value stored successfully")
    }
}