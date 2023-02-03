//
//  Accumulator.swift
//  AccumulateBag
//
//  Created by mars on 2021/10/25.
//

import Foundation

private var accumulators: [String: Accumulator] = [:]

public class Accumulator {
    public enum ReportStrategy {
        case immediately
        case launch
        case foreground
        case background
    }
    public var network: Network?   // 数据同步网络
    fileprivate var networkQueue = DispatchQueue(label: "com.AccumulateBag.report")
    public var coder: PackCoding = PackCoding<DecodeValue, EncodeValue>()
    public var collector = Collector()
    public var strategy: ReportStrategy = .immediately

    fileprivate let flag: String
    fileprivate init(flag: String) {
        self.flag = flag
    }
}

public extension Accumulator {
    class func accumulator(flag: String = ".default") -> Accumulator {
        if let acc = accumulators[flag] {
            return acc
        }
        let acc = Accumulator(flag: flag)
        accumulators[flag] = acc
        return acc
    }

    class func config(flag: String = ".default", handle: (Accumulator) -> Void = { _ in }) {
        let acc = accumulator(flag: flag)
        handle(acc)
    }

    class func config(flag: String = ".default", network: Network) {
        let acc = accumulator(flag: flag)
        acc.network = network
    }
}

public extension Accumulator {
    func increment(label: String, count: Int64, key: String, value: [String: Any], flag: Int = 0) {
        let value = CounterValue(label: label, count: count, key: key, value: value, cFlag: 0)
        switch strategy {
        case .immediately:
            immediatelyReport(values: [value])
        default:
            _ = collector.add(value: value)
        }
    }

    func start(label: String, time: String, key: String = "", value: [String: Any] = [:]) {
        let value = DurationValue(label: label, time: time, key: key, value: value, cFlag: 0)
        _ = collector.add(value: value)
    }
    
    func end(label: String, time: String, key: String = "", value: [String: Any] = [:]) {
        guard let item = collector.getItem(label: label) else {
            return
        }
        let value = DurationValue(label: label, time: time, key: key, value: value, cFlag: 1)
        let status = item.add(value: value)
        if status == false {
            return
        }

        switch strategy {
        case .immediately:
            _ = collector.popItem(key: item.value.label)
            immediatelyReport(values: [item.value])
        default:
            break
        }
    }
}

extension Accumulator {
    fileprivate func immediatelyReport(values: [Value]) {
        network?.report(data: values, in: networkQueue, completed: {
            print("report finish")
        })
    }
}
