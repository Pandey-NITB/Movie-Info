//
//  CustomCache.swift
//  Movies Info
//
//  Created by Prashant Pandey on 01/09/22.
//

import Foundation

public let LRUCacheMemoryWarningNotification: NSNotification.Name =
    .init("LRUCacheMemoryWarningNotification")

public final class CustomCache<Key: Hashable, Value> {
    private var values: [Key: Container] = [:]
    private unowned(unsafe) var head: Container?
    private unowned(unsafe) var tail: Container?
    private let lock: NSLock = .init()
    private var token: AnyObject?
    private let notificationCenter: NotificationCenter
    
    public var countLimit: Int {
        didSet {
            clean()
        }
    }

    public init(
        countLimit: Int = .max,
        notificationCenter: NotificationCenter = .default){
        self.countLimit = countLimit
        self.notificationCenter = notificationCenter

        self.token = notificationCenter.addObserver(
            forName: LRUCacheMemoryWarningNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.removeAllValues()
        }
    }

    deinit {
        if let token = token {
            notificationCenter.removeObserver(token)
        }
    }
}

public extension CustomCache {
    var count: Int {
        values.count
    }
    
    var isEmpty: Bool {
        values.isEmpty
    }
    
    func setValue(_ value: Value?, forKey key: Key, cost: Int = 0) {
        guard let value = value else {
            removeValue(forKey: key)
            return
        }
        lock.lock()
        if let container = values[key] {
            container.value = value
            remove(container)
            append(container)
        } else {
            let container = Container(
                value: value,
                cost: cost,
                key: key
            )
            values[key] = container
            append(container)
        }
        lock.unlock()
        clean()
    }

    @discardableResult func removeValue(forKey key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }
        guard let container = values.removeValue(forKey: key) else {
            return nil
        }
        remove(container)
        return container.value
    }

    func value(forKey key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }
        if let container = values[key] {
            remove(container)
            append(container)
            return container.value
        }
        return nil
    }

    func removeAllValues() {
        lock.lock()
        values.removeAll()
        head = nil
        tail = nil
        lock.unlock()
    }
}

private extension CustomCache {
    final class Container {
        var value: Value
        var cost: Int
        let key: Key
        unowned(unsafe) var prev: Container?
        unowned(unsafe) var next: Container?

        init(value: Value, cost: Int, key: Key) {
            self.value = value
            self.cost = cost
            self.key = key
        }
    }

    // Remove container from list
    func remove(_ container: Container) {
        if head === container {
            head = container.next
        }
        if tail === container {
            tail = container.prev
        }
        container.next?.prev = container.prev
        container.prev?.next = container.next
        container.next = nil
    }

    // Append container to list
    func append(_ container: Container) {
        assert(container.next == nil)
        if head == nil {
            head = container
        }
        container.prev = tail
        tail?.next = container
        tail = container
    }

    func clean() {
        lock.lock()
        defer { lock.unlock() }
        while count > countLimit,
              let container = head
        {
            remove(container)
            values.removeValue(forKey: container.key)
        }
    }
}
