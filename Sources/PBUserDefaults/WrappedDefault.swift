//
//  WrappedDefault.swift
//  PBUserDefaults
//
//  Created by HASAN CAN on 9/5/21.
//

import Foundation

/// A property wrapper that uses `UserDefaults` as a backing store,
/// whose `wrappedValue` is non-optional and registers a **non-optional default value**.
@propertyWrapper
public struct WrappedDefault<T: UserDefaultsSerializable> {
    private let _userDefaults: UserDefaults

    /// The key for the value in `UserDefaults`.
    public let key: String

    /// The value retreived from `UserDefaults`.
    public var wrappedValue: T {
        get {
            _userDefaults.fetch(key)
        }
        set {
            _userDefaults.save(newValue, for: key)
        }
    }

    /// Initializes the property wrapper.
    /// - Parameters:
    ///   - keyName: The key for the value in `UserDefaults`.
    ///   - defaultValue: The default value to register for the specified key.
    ///   - userDefaults: The `UserDefaults` backing store. The default value is `.standard`.
    public init(keyName: String,
                defaultValue: T,
                userDefaults: UserDefaults = .standard) {
        key = keyName
        _userDefaults = userDefaults
        userDefaults.registerDefault(value: defaultValue, key: keyName)
    }
}
