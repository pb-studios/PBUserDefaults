//
//  WrappedDefaultOptional.swift
//  PBUserDefaults
//
//  Created by HASAN CAN on 9/5/21.
//

import Foundation

/// A property wrapper that uses `UserDefaults` as a backing store,
/// whose `wrappedValue` is optional and **does not provide default value**.
@propertyWrapper
public struct WrappedDefaultOptional<T: UserDefaultsSerializable> {
    private let _userDefaults: UserDefaults

    /// The key for the value in `UserDefaults`.
    public let key: String

    /// The value retreived from `UserDefaults`, if any exists.
    public var wrappedValue: T? {
        get {
            _userDefaults.fetchOptional(key)
        }
        set {
            if let newValue = newValue {
                _userDefaults.save(newValue, for: key)
            } else {
                _userDefaults.delete(for: key)
            }
        }
    }

    /// Initializes the property wrapper.
    /// - Parameters:
    ///   - keyName: The key for the value in `UserDefaults`.
    ///   - userDefaults: The `UserDefaults` backing store. The default value is `.standard`.
    public init(keyName: String,
                userDefaults: UserDefaults = .standard) {
        key = keyName
        _userDefaults = userDefaults
    }
}
