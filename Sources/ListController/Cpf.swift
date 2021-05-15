//
//  Cpf.swift
//  CPFChain
//
//  Created by Aaron on 2017/11/16.
//  Copyright © 2017年 ruhnn. All rights reserved.
//

import Foundation

public class Cpf<Base> {
    /// 使用class + var以适应Protocol的使用
    /// 外部不应修改此变量；仅适用于引用类型
    public var base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol CpfCompatible {
    associatedtype CompatibleType
    
    static var cpf: Cpf<CompatibleType>.Type { get }
    var cpf: Cpf<CompatibleType> { get }
}

extension CpfCompatible {
    public static var cpf: Cpf<Self>.Type {
        return Cpf<Self>.self
    }
    
    public var cpf: Cpf<Self> {
        return Cpf(self)
    }
}

extension NSObject: CpfCompatible { }
extension NSProxy: CpfCompatible {}
