//
//  UserDefaults+Extensions.swift
//  PBUserDefaults
//
//  Created by HASAN CAN on 9/5/21.
//

import Foundation

extension UserDefaults {
    static func testSuite(name: String = UUID().uuidString) -> UserDefaults {
        UserDefaults().reset(name: name)
        return UserDefaults(suiteName: name)!
    }

    func reset(name: String = Bundle.main.bundleIdentifier!) {
        self.removePersistentDomain(forName: name)
    }
}
