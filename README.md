# PBUserDefaults

A lightweight [property wrapper](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html#ID348) for UserDefaults.

## About

Read the post: [A better approach to writing a UserDefaults Property Wrapper](https://www.jessesquires.com/blog/2021/03/26/a-better-approach-to-writing-a-userdefaults-property-wrapper/)

## Usage

You can use `@WrappedDefault` for non-optional values and `@WrappedDefaultOptional` for optional ones.
You may wish to store all your user defaults in one place, however, that is not necessary. **Any** property on **any type** can use this wrapper.

```swift
final class AppSettings {
    static let shared = AppSettings()

    @WrappedDefault(keyName: "flagEnabled", defaultValue: true)
    var flagEnabled: Bool

    @WrappedDefault(keyName: "totalCount", defaultValue: 0)
    var totalCount: Int

    @WrappedDefaultOptional(keyName: "timestamp")
    var timestamp: Date?
}

// Usage

func userDidToggleSetting(_ sender: UISwitch) {
    AppSettings.shared.flagEnabled = sender.isOn
}
```

There is also an included example app project.

### Using `enum` keys

If you prefer using an `enum` for the keys, writing an extension specific to your app is easy. However, this is not required. In fact, unless you have a specific reason to reference the keys, this is completely unneccessary.

```swift
enum AppSettingsKey: String, CaseIterable {
    case flagEnabled
    case totalCount
    case timestamp
}

extension WrappedDefault {
    init(key: AppSettingsKey, defaultValue: T) {
        self.init(keyName: key.rawValue, defaultValue: defaultValue)
    }
}

extension WrappedDefaultOptional {
    init(key: AppSettingsKey) {
        self.init(keyName: key.rawValue)
    }
}
```

### Observing with Combine

To support KVO monitoring via Combine, use the `NSObject.KeyValueObservingPublisher` helpers [provided by Apple](https://developer.apple.com/documentation/combine/performing-key-value-observing-with-combine). This requires your object to inherit from `NSObject` and adding `@objc dynamic` to the properties you would like to observe:

```swift
final class AppSettings: NSObject {
    static let shared = AppSettings()

    @WrappedDefaultOptional(keyName: "nickname")
    @objc dynamic var nickname: String?
}

// Usage

AppSettings.shared
    .publisher(for: \.nickname, options: [.new])
    .sink { print($0) }
    .store(in: &cancellable)

AppSettings.shared.nickname = "abc123"
// prints "abc123" from `.sink`
```

### Supported types

The following types are supported by default for use with `@WrappedDefault`.

Adding support for custom types is possible by conforming to `UserDefaultsSerializable`. However, **this is highly discouraged**. `UserDefaults` is not intended for storing complex data structures and object graphs. You should probably be using a proper database (or serializing to disk via `Codable`) instead.

- `Bool`
- `Int`
- `UInt`
- `Float`
- `Double`
- `String`
- `URL`
- `Date`
- `Data`
- `Array`
- `Set`
- `Dictionary`
- `RawRepresentable` types

## Additional Resources

- [NSUserDefaults in Practice](http://dscoder.com/defaults.html), the excellent guide by [David Smith](https://twitter.com/Catfish_Man)
- [UserDefaults documentation](https://developer.apple.com/documentation/foundation/userdefaults)
- [Preferences and Settings Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/UserDefaults/Introduction/Introduction.html#//apple_ref/doc/uid/10000059i-CH1-SW1)
- [Property List Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/PropertyLists/Introduction/Introduction.html#//apple_ref/doc/uid/10000048i)

## Supported Platforms

- iOS 12.0+
- tvOS 12.0+
- watchOS 5.0+
- macOS 10.13+

## Requirements

- Swift 5.3+
- Xcode 12.0+
- [SwiftLint](https://github.com/realm/SwiftLint)

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

```swift
dependencies: [
    .package(url: "git@github.com:pb-studios/PBUserDefaults.git", from: "v1.0.0")
]
```

Alternatively, you can add the package [directly via Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

## License

Released under the MIT License. See `LICENSE` for details.

> **Copyright &copy; 2021 PB Studios.**
