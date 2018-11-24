//
//  Settings.swift
//  Swifty
//
//  Created by Vadim Pavlov on 10/20/17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public protocol SettingKey {
    init?(rawValue: String)
    var rawValue: String { get }

    // Keys to delete on clearAll() method
    static var allKeys: [Self] { get }
}

public protocol SettingValue {}

extension Bool: SettingValue {}
extension String: SettingValue {}
extension NSString: SettingValue {}

extension URL: SettingValue {}
extension Data: SettingValue {}

extension Int: SettingValue {}
extension Float: SettingValue {}
extension Double: SettingValue {}
extension NSNumber: SettingValue {}

extension Array: SettingValue where Element: SettingValue {}
extension Dictionary: SettingValue where Value: SettingValue {}

open class Settings<Key: SettingKey> {
    
    public let defaults: UserDefaults
    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    public func clearAll() {
        Key.allKeys.forEach {
            self.set(value: nil, forKey: $0)
        }
    }

    public func clear(_ key: Key) {
        self.set(value: nil, forKey: key)
    }
    
    public subscript<Value: SettingValue>(key: Key) -> Value? {
        set { self.set(value: newValue, forKey: key) }
        get { return self.get(key: key) as? Value }
    }

    public subscript<E: RawRepresentable>(key: Key) -> E? {
        set { self.set(value: newValue?.rawValue, forKey: key) }
        get {
            let raw = self.get(key: key) as? E.RawValue
            return raw.flatMap(E.init)
        }
    }

    public func set<Object: Codable>(_ object: Object?, key: Key) {
        if let object = object {
            let encoder = PropertyListEncoder()
            let data = try? encoder.encode(object)
            self.set(value: data, forKey: key)
        } else {
            self.set(value: nil, forKey: key)
        }
    }

    public func object<Object: Codable>(_ key: Key) -> Object? {
        let decoder = PropertyListDecoder()
        let data = self.get(key: key) as? Data
        let object = data.flatMap { try? decoder.decode(Object.self, from: $0) }
        return object
    }

    /*
    public subscript<Object: Codable>(key: Key) -> Object? {
        set {
            if let value = newValue as? SettingValue {
                self.set(value: value, forKey: key)
            } else if let object = newValue {
                let encoder = PropertyListEncoder()
                let data = try? encoder.encode(object)
                self.set(value: data, forKey: key)
            } else {
                self.set(value: newValue, forKey: key)
            }
        }
        get {
            let decoder = PropertyListDecoder()
            let data = self.get(key: key) as? Data
            let object = data.flatMap { try? decoder.decode(Object.self, from: $0) }
            return object
        }
    }
    */

    public func object<Object: Codable>(key: Key) -> Object? {
        let decoder = PropertyListDecoder()
        let data = self.get(key: key) as? Data
        let object = data.flatMap { try? decoder.decode(Object.self, from: $0) }
        return object
    }
}

private extension Settings {
    func set(value: Any?, forKey settingKey: Key) {
        let key = settingKey.rawValue
        if let newValue = value {
            defaults.set(newValue, forKey: key)
        } else {
            defaults.removeObject(forKey: key)
        }
    }
    
    func get(key settingKey: Key) -> Any? {
        let key = settingKey.rawValue
        return defaults.object(forKey: key)
    }
}
