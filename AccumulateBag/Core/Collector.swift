//
//  Collector.swift
//  AccumulateBag
//
//  Created by mars on 2021/10/25.
//

import Foundation

 public class Collector {
    fileprivate var items: [String: CollectItem] = [:]
    fileprivate var lock = NSLock()
    func add(value: Value) -> CollectItem? {
        lock.lock()
        defer {
            lock.unlock()
        }
        if let item = items[value.label] {
            let status = item.add(value: value)
            if status == false {
                return .none
            }
            return item
        }

        let item = CollectItem(value: value)
        items[value.label] = item
        return item
    }
    
    func popItem(key: String) -> CollectItem? {
        lock.lock()
        defer {
            lock.unlock()
        }
        let item = items.removeValue(forKey: key)
        return item
    }
    
    func getItem(label: String) -> CollectItem? {
        lock.lock()
        defer {
            lock.unlock()
        }
        let item = items[label]
        return item
    }

    func cleanAll() {
        lock.lock()
        defer {
            lock.unlock()
        }
        items.removeAll()
    }

    func clean(tag: String) {
        lock.lock()
        defer {
            lock.unlock()
        }
        items[tag] = .none
    }

    func clean(tags: [String] = []) {
        lock.lock()
        defer {
            lock.unlock()
        }
        if tags.count <= 0 {
            items.removeAll()
        } else {
            for tag in tags {
                items[tag] = .none
            }
        }
    }
}
