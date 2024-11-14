//
//  Extension.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

extension HTTPURLResponse {
    func isSuccess() -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
}
