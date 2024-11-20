//
//  SelectedTaskTableViewCell.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 20.11.2024.
//

import UIKit
import SnapKit

final class SelectedTaskTableViewCell: UITableViewCell {
    static let reuseID: String = UUID().uuidString
    
    private lazy var titleLabel: UILabel = {
        $0.textAlignment = .left
        $0.font = .getFont(fontType: .regular, size: 17)
        return $0
    }(UILabel())
    
    private lazy var iconView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    func setupCell(with item: EditData) {
        addSubviews(titleLabel, iconView)
        
        titleLabel.text = item.text
        iconView.image = UIImage(systemName: item.imageName)
        
        switch item.type {
        case .remove:
            titleLabel.textColor = .alarm
            iconView.tintColor = .alarm
        default:
            titleLabel.textColor = .mainTheme
            iconView.tintColor = .mainTheme
        }
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(40)
        }
        
        iconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.width.height.equalTo(16)
        }
    }
}
