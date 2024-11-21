//
//  Response.ext.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 19.11.2024.
//

import Foundation

// MARK: - prodvides response status check

extension HTTPURLResponse {
    func isSuccess() -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
}
