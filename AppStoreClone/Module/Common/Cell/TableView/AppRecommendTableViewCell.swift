//
//  AppDownloadTableViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/25.
//

import UIKit

import RxRelay
import RxSwift

class AppRecommendTableViewCell: UITableViewCell {
    
    private var disposeBag = DisposeBag()
    let viewModel: AppRecommendTableViewCellViewModelType
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemBlue
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()
    private let descText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let download: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("받기", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let paymentType: UILabel = {
        let label = UILabel()
        label.text = "앱 내 구입"
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        viewModel = AppRecommendTableViewCellViewModel()
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
        descText.text = nil
        iconImageView.image = nil
    }
}


private extension AppRecommendTableViewCell {
    
    func bind() {
        viewModel.output.titleString
            .drive(titleText.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.descString
            .drive(descText.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.iconImage
            .drive(iconImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    func setConstraint() {
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            iconImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        textStackView.addArrangedSubview(titleText)
        textStackView.addArrangedSubview(descText)
        contentView.addSubview(textStackView)
        NSLayoutConstraint.activate([
            textStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            textStackView.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor)
        ])
        
        contentView.addSubview(download)
        NSLayoutConstraint.activate([
            download.widthAnchor.constraint(equalToConstant: 60),
            download.heightAnchor.constraint(equalToConstant: 30),
            download.leadingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: 4),
            download.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            download.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.addSubview(paymentType)
        NSLayoutConstraint.activate([
            paymentType.centerXAnchor.constraint(equalTo: download.centerXAnchor),
            paymentType.topAnchor.constraint(equalTo: download.bottomAnchor, constant: 4),
            paymentType.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }
}
