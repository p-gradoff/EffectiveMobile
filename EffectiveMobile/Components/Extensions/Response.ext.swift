//
//  Response.ext.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 19.11.2024.
//

import Foundation

extension HTTPURLResponse {
    func isSuccess() -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
}
