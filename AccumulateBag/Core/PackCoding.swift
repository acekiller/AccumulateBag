//
//  PackCoding.swift
//  AccumulateBag
//
//  Created by mars on 2021/10/25.
//

import Foundation

public protocol PackEcodeValue {
    func decode() -> PackDecodeValue
}

public protocol PackDecodeValue {
    func append(key: String, value: Value)
    func encode() -> PackEcodeValue
}

public class PackCoding<D, E> where D: PackDecodeValue, E: PackEcodeValue {
    typealias DecodedType = D
    typealias EncodedType = E

    func encode(value: D) -> E {
        let encode = value.encode()
        assert(decode is E)
        return encode as! E
    }

    func decode(data: E) -> D {
        let decode = data.decode()
        assert(decode is D)
        return decode  as! D
    }

    func newData(to: D, key: String, value: Value) -> D {
        to.append(key: key, value: value)
        return to
    }
}

public class EncodeValue: PackEcodeValue {
    public func decode() -> PackDecodeValue {
        return DecodeValue()
    }
}

public class DecodeValue: PackDecodeValue {
    public func encode() -> PackEcodeValue {
        return EncodeValue()
    }

    public func append(key: String, value: Value) {
    }
}
