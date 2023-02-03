//
//  Model.swift
//  AccumulateBag
//
//  Created by mars on 2021/10/25.
//

import Foundation

public protocol Value {
    var label: String { get }
    func merge(value: Value) -> Bool    //数据合并状态false 表示合并失败， true表示合并成功
    func value() -> (label: String, calcNum: Int64, param: [String: [String: Any]])
}

class CounterValue: Value {
    var label: String
    var count: Int64
    var cFlag: Int  // 客户端自定义标记
    var params: [String: [String: Any]] = [:]

    init(label: String, count: Int64, key: String = "", value: [String: Any] = [:], cFlag: Int = 0) {
        self.label = label
        self.count = count
        if !key.isEmpty && !value.isEmpty {
            self.params[key] = value
        }
        self.cFlag = cFlag
    }

    func merge(value: Value) -> Bool {
        guard let v = value as? CounterValue else {
            return false
        }
        return increment(count: v.count, params: v.params)
    }

    func increment(count: Int64, key: String = "", value: [String: Any] = [:]) -> Bool {
        self.count += count
        if !key.isEmpty && !value.isEmpty {
            self.params[key] = value
        }
        return true
    }

    func increment(count: Int64, params: [String: [String: Any]]) -> Bool {
        self.count += count
        for (key, value) in params {
            if !key.isEmpty && !value.isEmpty {
                self.params[key] = value
            }
        }
        return true
    }

    func value() -> (label: String, calcNum: Int64, param: [String : [String : Any]]) {
        return (label, count, params)
    }
}

class DurationValue: Value {
    var label: String
    var cFlag: Int  // 1表示开始， 2表示结束
    var params: [String: [String: Any]] = [:]
    init(label: String, time: String, key: String = "", value: [String: Any] = [:], cFlag: Int = 0) {
        self.label = label
        var input_value = value
        if cFlag == 0 {
            input_value["startTime"] = time
        } else {
            input_value["endTime"] = time
        }
        
        if !key.isEmpty && !input_value.isEmpty {
            var result = self.params[key] ?? [:]
            for (k, v) in input_value {
                result[k] = v
            }
            self.params[key] = result
        }
        self.cFlag = cFlag
    }
    
    func merge(value: Value) -> Bool {
        guard let v = value as? DurationValue, v.cFlag == 1 || v.params.count <= 0 else {
            return false
        }
        for (key, value) in v.params {
            if value.isEmpty {
                continue
            }
            guard var result = self.params[key] else {
                self.params[key] = value
                return true
            }
            for (k, v) in value {
                result[k] = v
            }
            self.params[key] = result
        }
        return true
    }

    func value() -> (label: String, calcNum: Int64, param: [String : [String : Any]]) {
        return (label, 1, params)
    }
}
