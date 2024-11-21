//
//  InitialLaunchManager.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation

// MARK: - defines the order in which the programme is to be started. After the first start it changes the flag

struct LaunchManager {
    private static let firstLaunchKey = "First launch"

    // MARK: - only on the first run the result will be true
    static func isInitialLaunch() -> Bool {
        // UserDefaults.standard.removeObject(forKey: firstLaunchKey)
        guard let _ = UserDefaults.standard.object(forKey: firstLaunchKey) else {
            UserDefaults.standard.set(false, forKey: firstLaunchKey)
            return true
        }
        return false
    }
}
