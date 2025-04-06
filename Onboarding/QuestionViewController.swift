//
//  QuestionViewController.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import UIKit
import SnapKit

protocol PageNavigationDelegate: AnyObject {
    func goToNextPage()
}

// MARK: - QuestionViewController
class QuestionViewController: UIViewController {
    
    var pageIndex: Int = 0
    var question: Question
    weak var pageDelegate: PageNavigationDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's setup App for you"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = question.questionText
        //label.font = UIFont.systemFont(ofSize: 20)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(AnswerCell.self, forCellReuseIdentifier: "AnswerCell")
        table.separatorStyle = .none
        table.backgroundColor = .clear
        return table
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .white
        button.setTitleColor(.lightGray, for: .normal)
        button.layer.cornerRadius = 22
        button.isEnabled = false
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var selectedAnswerIndex: Int?
    
    init(question: Question) {
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        
        view.addSubview(titleLabel)
        view.addSubview(questionLabel)
        view.addSubview(tableView)
        view.addSubview(continueButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.left.right.equalToSuperview().inset(20)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(35)
            make.left.right.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(continueButton.snp.top).offset(-20)
        }
        
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
    }
    
    @objc func continueButtonTapped() {
        pageDelegate?.goToNextPage()
    }
}

// MARK: - UITableViewDataSource_UITableViewDelegate
extension QuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.possibleAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
        cell.configure(with: question.possibleAnswers[indexPath.row], isSelected: selectedAnswerIndex == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswerIndex = indexPath.row
        continueButton.isEnabled = true
        continueButton.backgroundColor = .black
        continueButton.setTitleColor(.white, for: .normal)
        tableView.reloadData()
    }
}
