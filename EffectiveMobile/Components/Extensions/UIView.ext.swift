//
//  UIView.ext.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 19.11.2024.
//

import Foundation
import UIKit

// MARK: - provides multiple additing subview

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}


