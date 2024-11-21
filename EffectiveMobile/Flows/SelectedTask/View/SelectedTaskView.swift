//
//  SelectedTaskView.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 20.11.2024.
//

import UIKit
import SnapKit
import VisualEffectView

// MARK: - view that presents the selected task and provides a menu for interacting with it

protocol SelectedTaskViewInput: AnyObject {
    var output: SelectedTaskViewOutput? { get set }
    func setSelectedTask(_ data: Task)
    func setTableData(with data: [EditData])
}

protocol SelectedTaskViewOutput: AnyObject {
    func getEditTableData()
}

// MARK: - allows the parent controller to know which task to perform an action on
protocol DismissDelegate: AnyObject {
    func dismissController(withAction action: EditDataRequestCollection?, taskId id: Int?)
}

final class SelectedTaskView: UIViewController {
    // MARK: - output  is presenter and delegate is parent controller
    weak var delegate: DismissDelegate?
    var output: SelectedTaskViewOutput?

    // MARK: - private properties
    private var selectedTaskData: Task!
    private var tableData: [EditData] = []
    
    private let visualEffectView: VisualEffectView = {
        $0.blurRadius = 10
        $0.colorTint = .mainTheme
        $0.colorTintAlpha = 0.3
        $0.scale = 5
        return $0
    }(VisualEffectView())
    
    private lazy var contentView: UIView = {
        $0.backgroundColor = .clear
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UIView())
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        $0.addTarget(self, action: #selector(tapGest(sender: )))
        return $0
    }(UITapGestureRecognizer())
    
    // MARK: - this controller is dismissed only when pressed outside the canvas view
    @objc private func tapGest(sender: UITapGestureRecognizer) {
        delegate?.dismissController(withAction: nil, taskId: nil)
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
        $0.numberOfLines = .zero
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
    
    // MARK: - view controller cycle
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
        updateViews()
    }
    
    // MARK: - views initialization
    private func setupView() {
        canvasView.addSubview(labelStack)
        contentView.addSubviews(canvasView, editTableView)
        visualEffectView.contentView.addSubview(contentView)
        view.addSubview(visualEffectView)
        view.backgroundColor = .clear
        
        visualEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
    
    // MARK: - updates the data, if any
    private func updateViews() {
        titleLabel.text = selectedTaskData.title
        descriptionLabel.text = selectedTaskData.todo
        dateLabel.text = selectedTaskData.createdAt
    }
}

// MARK: - menu tableView methods
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
    
    // MARK: - depending on the selected cell, sends the id and the required action to the delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowItem = tableData[indexPath.row]
        switch selectedRowItem.type {
        case .edit:
            delegate?.dismissController(withAction: .edit, taskId: selectedTaskData.id)
        case .share:
            delegate?.dismissController(withAction: .share, taskId: selectedTaskData.id)
        case .remove:
            delegate?.dismissController(withAction: .remove, taskId: selectedTaskData.id)
        }
    }
}

// MARK: - gesture recognizer
extension SelectedTaskView: UIGestureRecognizerDelegate {
    // MARK: - this gesture works only when tapped outside the canvasView and tableView area
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touch.view == contentView ? true : false
    }
}

// MARK: - methods that allows the view to get information
extension SelectedTaskView: SelectedTaskViewInput {
    // MARK: - set tableView data and reload it to show
    func setTableData(with data: [EditData]) {
        tableData = data
        editTableView.reloadData()
    }
    
    // MARK: - set received selected task data
    func setSelectedTask(_ data: Task) {
        selectedTaskData = data
    }
}
