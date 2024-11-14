//
//  InitialLaunchManager.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation

struct LaunchManager {
    private static let firstLaunchKey = "First launch"

    static func isInitialLaunch() -> Bool {
        guard let flag = UserDefaults.standard.object(forKey: firstLaunchKey) else {
            UserDefaults.standard.set(false, forKey: firstLaunchKey)
            return true
        }
        return false
    }
}
