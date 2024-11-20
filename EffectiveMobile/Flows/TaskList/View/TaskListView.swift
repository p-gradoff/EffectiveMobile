//
//  TaskListView.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import UIKit
import SnapKit

protocol TaskListViewInput: AnyObject {
    var output: TaskListViewOutput? { get set }
    func setTableData(with data: [Task])
}

protocol TaskListViewOutput: AnyObject {
    func getTasks()
    func changeTaskCompletionStatus(by id: Int)
    func goToSelectedTask(_ task: Task)
}

protocol TaskTableViewCellDelegate: AnyObject {
    func saveCompletionChanges(at indexPath: IndexPath)
}

final class TaskListView: UIViewController {
    
    private var tableData: [Task] = []
    var output: TaskListViewOutput?
    
    private let blurView: UIVisualEffectView = UIVisualEffectView()
    private let vibrancyEffect: UIVibrancyEffect = UIVibrancyEffect()
    
    private lazy var tableView: UITableView = {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.separatorInset = .zero
        $0.separatorStyle = .singleLine
        $0.separatorColor = .button
        $0.layoutMargins = .zero
        $0.bounces = false
        $0.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseID)
        return $0
    }(UITableView())
    
    private let bottomView: UIView = {
        $0.backgroundColor = .additionTheme
        return $0
    }(UIView())
    
    private lazy var taskCounter: UILabel = {
        $0.textColor = .primaryText
        $0.textAlignment = .left
        $0.font = .getFont(fontType: .regular, size: 11)
        return $0
    }(UILabel())
    
    // TODO: MAKE TEXT FORMATTER
    private lazy var taskLabel: UILabel = {
        $0.textColor = .primaryText
        $0.text = "Задач"
        $0.textAlignment = .left
        $0.font = .getFont(fontType: .regular, size: 11)
        return $0
    }(UILabel())
    
    private lazy var taskLabelStack: UIStackView = { stack in
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .equalSpacing
        [taskCounter, taskLabel].forEach { label in
            stack.addArrangedSubview(label)
        }
        return stack
    }(UIStackView())
    
    private let createButton: UIButton = {
        $0.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .accent
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .mainTheme
        bottomView.addSubviews(taskLabelStack, createButton)
        view.addSubviews(tableView, bottomView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(50)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        taskLabelStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(13)
        }
        
        createButton.snp.makeConstraints {
            $0.centerY.equalTo(taskLabelStack.snp.centerY)
            $0.trailing.equalToSuperview().inset(40)
            $0.width.height.equalTo(20)
        }
    }
    
    private func resaveTask(by id: Int) {
        output?.changeTaskCompletionStatus(by: id)
    }
    
    /*
    private func updateViewTransparency() {
        for view in self.view.subviews {
            view.alpha = 0.5
        }
    }
    
    private func restoreViewTransparency() {
        for view in self.view.subviews {
            view.alpha = 1.0
        }
    }
    
    private func addBlur() {
        view.addSubview(blurView)
    }
     */
}

extension TaskListView: UITableViewDataSource, UITableViewDelegate, TaskTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = tableData.count
        if count == 0 {
            output?.getTasks()
        }
        taskCounter.text = String(count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseID, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
    
        cell.indexPath = indexPath
        cell.delegate = self
        cell.setupCell(with: tableData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // addBlur()
        output?.goToSelectedTask(tableData[indexPath.row])
        // updateViewTransparency()
    }
    
    func saveCompletionChanges(at indexPath: IndexPath) {
        // tableView.reloadRows(at: [indexPath], with: .none)
        
        let id = tableData[indexPath.row].id
        resaveTask(by: id)
    }
    
}


extension TaskListView: TaskListViewInput {
    func setTableData(with data: [Task]) {
        tableData = data
        tableView.reloadData()
    }
}

extension TaskListView: DismissDelegate {
    func dismissController(withAction action: EditDataRequestCollection?) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            guard let action else {
                return
            }
            switch action {
            case .edit:
                break
            case .share:
                break
            case .remove:
                output?.getTasks()
            }
        }
    }
}
