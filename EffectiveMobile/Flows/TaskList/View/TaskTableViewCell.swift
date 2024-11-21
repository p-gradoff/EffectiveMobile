//
//  TaskTableViewCell.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import UIKit
import SnapKit

final class TaskTableViewCell: UITableViewCell {
    static let reuseID: String = UUID().uuidString
    
    var delegate: TaskTableViewCellDelegate!
    var indexPath: IndexPath!
    private var completionStatus: Bool!
    
    private lazy var titleLabel: UILabel = {
        $0.font = .getFont(fontType: .medium)
        $0.textColor = .primaryText
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.font = .getFont(fontType: .regular, size: 12)
        $0.textColor = .primaryText
        $0.textAlignment = .left
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private lazy var dateLabel: UILabel = {
        $0.font = .getFont(fontType: .regular, size: 12)
        $0.textColor = .primaryText
        $0.alpha = 0.5
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var labelStack: UIStackView = { stack in
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        [titleLabel, descriptionLabel, dateLabel].forEach { label in
            stack.addArrangedSubview(label)
        }
        return stack
    }(UIStackView())
    
    private lazy var completionButton: UIButton = {
        $0.addTarget(self, action: #selector(changeCompletionStatus), for: .touchDown)
        return $0
    }(UIButton())
    
    private func taskInProgressSetup() {
        titleLabel.attributedText = NSAttributedString(string: titleLabel.text!)
        titleLabel.alpha = 1.0
        
        descriptionLabel.alpha = 1.0
        completionButton.tintColor = .button
        completionButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    private func completedTaskSetup() {
        let attrStrikethroughStyle: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)
        ]
        titleLabel.attributedText = NSAttributedString(string: titleLabel.text!, attributes: attrStrikethroughStyle)
        titleLabel.alpha = 0.5
        
        descriptionLabel.alpha = 0.5
        completionButton.tintColor = .accent
        completionButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    }
    
    func setupCell(with item: Task) {
        backgroundColor = .clear
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        
        titleLabel.text = item.title
        descriptionLabel.text = item.todo
        dateLabel.text = item.createdAt
        completionStatus = item.completed
        
        completionStatus ? completedTaskSetup() : taskInProgressSetup()
        
        addSubviews(completionButton, labelStack)
        
        completionButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        labelStack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalTo(completionButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.attributedText = nil
    }
    
    @objc private func changeCompletionStatus(_ sender: UIButton) {
        completionStatus.toggle()
        completionStatus ? completedTaskSetup() : taskInProgressSetup()
        
        delegate?.saveCompletionChanges(at: indexPath)
    }
}