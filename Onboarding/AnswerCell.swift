//
//  AnswerCell.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import UIKit
import SnapKit

// MARK: - AnswerCell
class AnswerCell: UITableViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        
        if isSelected {
            containerView.backgroundColor = UIColor(red: 71/255, green: 190/255, blue: 154/255, alpha: 1)
            titleLabel.textColor = .white
        } else {
            containerView.backgroundColor = .white
            titleLabel.textColor = .black
        }
    }
}
