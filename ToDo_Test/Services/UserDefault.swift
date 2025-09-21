//
//  UserDefault.swift
//  ToDo_Test
//
//  Created by Mustafo on 21/09/25.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value: Codable> {
    public let key: String
    public let name: String
    public var defaultValue: Value
    
    public var container: UserDefaults = .standard
    
    public var wrappedValue: Value {
        get {
            getFromUserDefaults(key: key) ?? defaultValue
        } set {
            saveToUserDefaults(value: newValue, name: name, key: key)
        }
    }
}

extension UserDefault {
    public func getFromUserDefaults(key: String) -> Value? {
        if let value = container.object(forKey: key) as? Value {
            return value
        } else if let data = container.data(forKey: key), let value = try? JSONDecoder().decode(Value.self, from: data) {
            return value
        }
        return defaultValue
    }
    
    public func saveToUserDefaults(value: Value?, name: String,key: String) {
        if let new = value {
            if new is Array<Encodable> {
                let data = try? JSONEncoder().encode(new)
                container.set(data, forKey: key)
            } else {
                print("[UserDefaults] \(name) \(String(describing: new)) stored.")
                container.set(new, forKey: key)
            }
        } else {
            print("[UserDefaults] \(name) removed.")
            container.removeObject(forKey: key)
        }
    }
}

