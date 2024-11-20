//
//  SelectedTaskView.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 20.11.2024.
//

import UIKit
import SnapKit

protocol SelectedTaskViewInput: AnyObject {
    var output: SelectedTaskViewOutput? { get set }
    func setSelectedTask(_ data: Task)
    func setTableData(with data: [EditData])
}

protocol SelectedTaskViewOutput: AnyObject {
    func removeTask(by id: Int)
    func getEditTableData()
}

protocol DismissDelegate: AnyObject {
    func dismissController(withAction action: EditDataRequestCollection?)
}

final class SelectedTaskView: UIViewController {

    private var selectedTaskData: Task!
    private var tableData: [EditData] = []
    weak var delegate: DismissDelegate?
    var output: SelectedTaskViewOutput?
    
    private lazy var contentView: UIView = {
        $0.backgroundColor = .mainTheme.withAlphaComponent(0.5)
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UIView())
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        $0.addTarget(self, action: #selector(tapGest(sender: )))
        return $0
    }(UITapGestureRecognizer())
    
    @objc private func tapGest(sender: UITapGestureRecognizer) {
        delegate?.dismissController(withAction: nil)
    }
    
    private let canvasView: UIView = {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .additionTheme
        return $0
    }(UIView())
    
    private lazy var titleLabel: UILabel = {
        $0.textColor = .primaryText
        $0.font = .getFont(fontType: .medium)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.font = .getFont(fontType: .regular, size: 12)
        $0.textColor = .primaryText
        $0.textAlignment = .left
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
    
    private lazy var editTableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.isScrollEnabled = false
        $0.separatorInset = .zero
        $0.separatorColor = .button
        $0.backgroundColor = .primaryText.withAlphaComponent(0.8)
        $0.layer.cornerRadius = 12
        $0.register(SelectedTaskTableViewCell.self, forCellReuseIdentifier: SelectedTaskTableViewCell.reuseID)
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .fullScreen
        isModalInPresentation = true
        tapGestureRecognizer.delegate = self
        setupView()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        updateView()
    }
    
    private func setupView() {
        canvasView.addSubview(labelStack)
        contentView.addSubviews(canvasView, editTableView)
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelStack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        canvasView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        editTableView.snp.makeConstraints {
            $0.top.equalTo(canvasView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(53)
            $0.height.equalTo(132)
        }
    }
    
    private func updateView() {
        titleLabel.text = selectedTaskData.title
        descriptionLabel.text = selectedTaskData.todo
        dateLabel.text = selectedTaskData.createdAt
    }
}

extension SelectedTaskView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableData.isEmpty {
            output?.getEditTableData()
        }
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableData[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedTaskTableViewCell.reuseID, for: indexPath) as? SelectedTaskTableViewCell else { return UITableViewCell() }
        
        cell.setupCell(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 44 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowItem = tableData[indexPath.row]
        switch selectedRowItem.type {
        case .edit:
            break
        case .share:
            delegate?.dismissController(withAction: .share)
        case .remove:
            output?.removeTask(by: selectedTaskData.id)
            delegate?.dismissController(withAction: .remove)
        }
    }
}

extension SelectedTaskView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touch.view == contentView ? true : false
    }
}

extension SelectedTaskView: SelectedTaskViewInput {
    func setTableData(with data: [EditData]) {
        tableData = data
        editTableView.reloadData()
    }
    
    func setSelectedTask(_ data: Task) {
        selectedTaskData = data
    }
}
