//
//  NewDiscoveryTableViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/24.
//

import UIKit

import RxRelay
import RxSwift

class NewDiscoveryTableViewCell: UITableViewCell {
    
    private let disposeBag = DisposeBag()
    let viewModel: NewDiscoveryTableViewCellViewModelType
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#D4D4D5", alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemBlue
        label.font = UIFont.systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        viewModel = NewDiscoveryTableViewCellViewModel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleText.text = nil
    }
}

private extension NewDiscoveryTableViewCell {
    
    func bind() {
        viewModel.output
            .drive(titleText.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setConstraint() {
        contentView.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.2)
        ])
        
        contentView.addSubview(titleText)
        NSLayoutConstraint.activate([
            titleText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleText.topAnchor.constraint(equalTo: separatorView.topAnchor, constant: 10),
            titleText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
