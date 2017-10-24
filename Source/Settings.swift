//
//  Settings.swift
//  Swifty
//
//  Created by Vadim Pavlov on 10/20/17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public protocol SettingKey {
    init?(stringValue: String)
    var stringValue: String { get }
}

public class Settings {
    fileprivate let defaults: UserDefaults
    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    public subscript<T>(key: SettingKey) -> T? {
        set { self.set(value: newValue, forKey: key) }
        get { return self.get(key: key) as? T }
    }
    
    public subscript<E: RawRepresentable>(key: SettingKey) -> E? {
        set { self.set(value: newValue?.rawValue, forKey: key) }
        get {
            let raw = self.get(key: key) as? E.RawValue
            return raw.flatMap(E.init)
        }
    }
}

private extension Settings {
    func set(value: Any?, forKey settingKey: SettingKey) {
        let key = settingKey.stringValue
        if let newValue = value {
            defaults.set(newValue, forKey: key)
        } else {
            defaults.removeObject(forKey: key)
        }
    }

    func get(key settingKey: SettingKey) -> Any? {
        let key = settingKey.stringValue
        return defaults.object(forKey: key)
    }
}
