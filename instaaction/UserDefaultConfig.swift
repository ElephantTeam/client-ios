//
//  UserDefaultConfig.swift
//  instaaction
//
//  Created by Marcin Mucha on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import Foundation

struct UserDefaultsConfig {
    @UserDefault("user", defaultValue: nil)
    static var user: User?
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
