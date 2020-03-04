//
//  CleanJSON.swift
//  CleanJSON
//
//  Created by Pircate on 2018/5/3.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK:-
public protocol MLDCodable: Codable {
    
    /// 将字典中的key对应到属性名
    ///
    /// - Returns: @return 字典中的key是字典中取值用的key，value是属性名
    static func replacedKeysFromDic() -> [String : String]?
    
    /// 将字典中的key对应到属性名
    ///
    /// - Returns: @return 属性名
    static func replacedKeyFromDic121(_ key:String) -> String?
    
    /// 这个数组中的属性名将会被忽略：不进行字典转模型
    static func ignoredPropertyNames() ->[String]?
    
    ///字典转模型
    static func model(from dic:[String : Any]? ) -> Self?
    
    /// 字典数组转模型数组
    ///（使用此方法当前类要使用final关键字）
    static func modelArray<T: MLDCodable>(form dicArray: Array<JSON>? ) -> Array<T>?
    
    /// 将模型转成json
    ///
    /// - Parameter ignoredPropertyNames: 要被忽略的属性数组
    /// - Returns: json
    func json(_ ignoredPropertyNames: [String]?) -> String?
    
    /// 将模型转成字典
    ///
    /// - Parameter ignoredPropertyNames: 要被忽略的属性数组
    /// - Returns: 字典
    func keyValues(_ ignoredPropertyNames: [String]?) -> [String : Any]?
    
    /// 将模型数组转成字典数组
    ///
    /// - Parameters:
    ///   - modelArray: 模型数组
    ///   - ignoredPropertyNames: 要被忽略的属性数组
    /// - Returns: 字典数组
    static func keyValuesArray<T:MLDCodable>(_ modelArray:[T]?, _ ignoredPropertyNames: [String]?) -> [[String : Any]]?
}

//MARK:- 可重写方法
extension MLDCodable {
    
    public static func replacedKeysFromDic() -> [String : String]? {
        return nil
    }
    
    public static func replacedKeyFromDic121(_ key:String) -> String? {
        return nil
    }
    public static func ignoredPropertyNames() ->[String]? {
        return nil
    }
}

//MARK:- 解析方法
public extension MLDCodable {
    
    static func model(from dic:[String : Any]? ) -> Self? {
        if dic == nil {
            return nil
        }
        let data = try! JSONSerialization.data(withJSONObject: dic!, options: [])
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .custom({ (keys) -> CodingKey in
            var key = keys.last!.stringValue
            if let replacedKeyDic = replacedKeysFromDic(),
                let v = replacedKeyDic[key] {
                key = v
            }
            if let key121 = replacedKeyFromDic121(key),
                key121 != key {
                key = key121
            }
            if let ignoredKeys = ignoredPropertyNames(),
                ignoredKeys.contains(key) {
                key = ""
            }
            return ModelKey(stringValue: key)!
        })
        /*复制本文件内 "MARK:- 解码" 模块至项目内*/
        let model = try? decoder.decode(Self.self, from: data)
        return model

    }
    
    static func modelArray<T: MLDCodable>(form dicArray: Array<JSON>? ) -> Array<T>? {
        if dicArray == nil {
            return nil
        }
        var tempArray = [T]()
        if dicArray != nil {
            for json in dicArray! {
                let dic = json.dictionaryObject
                if let model = T.model(from: dic) {
                    tempArray.append(model)
                }
            }
        }
        return tempArray
    }
    
    func json(_ ignoredPropertyNames:[String]? = nil) -> String? {
        guard let dic =  self.keyValues(ignoredPropertyNames) else { return nil}
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
    
    func keyValues(_ ignoredPropertyNames: [String]? = nil) -> [String : Any]? {
        let encoder = JSONEncoder()
        if ignoredPropertyNames != nil {
            encoder.keyEncodingStrategy = .custom({ (propertyNames) -> CodingKey in
                var propertyName = propertyNames.last!.stringValue
                if ignoredPropertyNames!.contains(propertyName){
                    propertyName = ""
                }
                return ModelKey(stringValue: propertyName)!
            })
        }
        if let jsonData = try? encoder.encode(self) {
            guard var dic = ((try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any]) as [String : Any]??) else { return nil }
            dic!.removeValue(forKey: "")
            return dic
        }
        return nil
    }
    
    static func keyValuesArray<T:MLDCodable>(_ modelArray:[T]?, _ ignoredPropertyNames: [String]? = nil) -> [[String : Any]]?{
        if modelArray == nil {
            return nil
        }
        var tempArray = [[String : Any]]()
        if modelArray != nil {
            for model in modelArray! {
                if let dic = model.keyValues(ignoredPropertyNames) {
                    tempArray.append(dic)
                }
            }
        }
        return tempArray
    }
}


//MARK:- Model
public struct ModelKey: CodingKey {
    public var stringValue: String
    public var intValue: Int?
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

//MARK:- 解码
// 复制下方解码模块至项目内
extension KeyedDecodingContainer {
    
    func decode(_ type: Bool.Type, forKey key: KeyedDecodingContainer.Key) throws -> Bool {
        return try decodeIfPresent(type, forKey: key) ?? false
    }
    
    func decode(_ type: String.Type, forKey key: KeyedDecodingContainer.Key) throws -> String {
        return try decodeIfPresent(type, forKey: key) ?? ""
    }
    
    func decode(_ type: Double.Type, forKey key: KeyedDecodingContainer.Key) throws -> Double {
        return try decodeIfPresent(type, forKey: key) ?? 0.0
    }
    
    func decode(_ type: Float.Type, forKey key: KeyedDecodingContainer.Key) throws -> Float {
        return try decodeIfPresent(type, forKey: key) ?? 0.0
    }
    
    func decode(_ type: Int.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int {
        return try decodeIfPresent(type, forKey: key) ?? 0
    }
    
    func decode(_ type: UInt.Type, forKey key: KeyedDecodingContainer.Key) throws -> UInt {
        return try decodeIfPresent(type, forKey: key) ?? 0
    }
    
    func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> T where T : Decodable {
        
        if let value = try decodeIfPresent(type, forKey: key) {
            return value
        } else if let objectValue = try? JSONDecoder().decode(type, from: "{}".data(using: .utf8)!) {
            return objectValue
        } else if let arrayValue = try? JSONDecoder().decode(type, from: "[]".data(using: .utf8)!) {
            return arrayValue
        } else if let stringValue = try decode(String.self, forKey: key) as? T {
            return stringValue
        } else if let boolValue = try decode(Bool.self, forKey: key) as? T {
            return boolValue
        } else if let intValue = try decode(Int.self, forKey: key) as? T {
            return intValue
        } else if let uintValue = try decode(UInt.self, forKey: key) as? T {
            return uintValue
        } else if let doubleValue = try decode(Double.self, forKey: key) as? T {
            return doubleValue
        } else if let floatValue = try decode(Float.self, forKey: key) as? T {
            return floatValue
        }
        let context = DecodingError.Context(codingPath: [key], debugDescription: "Key: <\(key.stringValue)> cannot be decoded")
        throw DecodingError.dataCorrupted(context)
    }
    
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        
        guard contains(key) else { return nil }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        return try? container.decode(type)
    }
    
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        
        guard contains(key) else { return nil }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        } else if let intValue = try? container.decode(Int.self) {
            return String(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            return String(doubleValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            return String(boolValue)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        
        guard contains(key) else { return nil }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            return Double(stringValue)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        
        guard contains(key) else { return nil }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            return Float(stringValue)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        
        guard contains(key) else { return nil }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            return Int(stringValue)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        
        guard contains(key) else { return nil }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            return UInt(stringValue)
        }
        return nil
    }
    
    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        
        guard contains(key) else { return nil }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        return try? container.decode(type)
    }
}

