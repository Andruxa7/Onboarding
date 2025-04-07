//
//  SuccessViewController.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//


import UIKit
import SnapKit

class SuccessViewController: UIViewController {
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "🎉"
        label.font = UIFont.systemFont(ofSize: 80)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium activated!"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You have successfully activated your 7-day trial period. Enjoy all the premium features!"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(emojiLabel)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        emojiLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emojiLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
    }
    
    @objc private func continueButtonTapped() {
        dismiss(animated: true)
    }
}
