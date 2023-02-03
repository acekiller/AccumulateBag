//
//  Network.swift
//  AccumulateBag
//
//  Created by mars on 2021/10/25.
//

import Foundation

public protocol Network {
    func report(data: [Value], in queue: DispatchQueue, completed: () -> Void)
}
