//
//  MLDNamespace.swift
//  SCRMInland
//
//  Created by MoliySDev on 2018/11/13.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import Foundation
import UIKit

//MARK:- 相关协议
public protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

//命名空间
public protocol MLDNamespaceWrappable {
    associatedtype WrapperType
    var mld: WrapperType { get }
    static var mld: WrapperType.Type { get }
}

public extension MLDNamespaceWrappable {
    var mld: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    static var mld: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

//MARK:-
//MARK:String扩展-mld命名空间
extension String : MLDNamespaceWrappable{}
//MARK:UIImageView扩展-mld命名空间
extension UIImageView : MLDNamespaceWrappable{}
//MARK:UIButton扩展-mld命名空间
extension UIButton : MLDNamespaceWrappable{}
//MARK:Double扩展-mld命名空间
extension Double : MLDNamespaceWrappable{}
//MARK:Int扩展-mld命名空间
extension Int : MLDNamespaceWrappable{}
//MARK:DispatchQueue-mld命名空间
extension DispatchQueue : MLDNamespaceWrappable{}


