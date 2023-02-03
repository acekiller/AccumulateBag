//
//  CollectItem.swift
//  AccumulateBag
//
//  Created by mars on 2021/10/25.
//

import Foundation

class CollectItem {
    var value: Value

    init(value: Value) {
        self.value = value
    }

    var label: String {
        value.label
    }

    func add(value: Value) -> Bool {
        return self.value.merge(value: value)
    }
}
