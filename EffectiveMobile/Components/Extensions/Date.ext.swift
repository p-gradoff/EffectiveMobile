//
//  Date.ext.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 19.11.2024.
//

import Foundation

// MARK: - provides string from date in type "dd/MM/yy"

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: self)
    }
}
