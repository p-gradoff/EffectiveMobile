//
//  Protocol.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 16.11.2024.
//

import Foundation
import UIKit

// MARK: - provides alert controller presenting to it's inheritants

protocol AlertProvider {
    func getAlertController(with title: String, _ message: String) -> UIAlertController
}
extension AlertProvider {
    func getAlertController(with title: String, _ message: String) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(alertAction)
        return alertController
    }
}
