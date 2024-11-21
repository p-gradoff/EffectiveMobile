//
//  Font.ext.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 19.11.2024.
//

import UIKit

// MARK: - provides simple way to get custom font

enum FontType: String {
    case regular = "SFUIText-Regular"
    case medium = "SFUIText-Medium"
    case bold = "SFUIText-Bold"
}

extension UIFont {
    static func getFont(fontType: FontType, size: CGFloat = 16) -> UIFont {
        .init(name: fontType.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}
