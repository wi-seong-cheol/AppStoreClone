//
//  SearchAppTableViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/05.
//

import UIKit

import RxRelay
import RxSwift

class SearchAppTableViewCell: UITableViewCell {
    
    private var disposeBag = DisposeBag()
    let viewModel: SearchAppTableViewCellViewModelType
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 13
        button.setTitle("받기", for: .normal)
        button.backgroundColor = .systemGray4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let starRatingView = StarRatingView()
    private let previewStackView = PreviewStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        viewModel = SearchAppTableViewCellViewModel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        iconImageView.image = nil
    }
}

private extension SearchAppTableViewCell {
    
    private func bind() {
        viewModel.output.titleString
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.descString
            .drive(descLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.iconImage
            .drive(iconImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.output.previewImages
            .filter { !$0.isEmpty }
            .drive(onNext: { [weak self] images in
                self?.previewStackView.input.images.onNext(images)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.starRating
            .drive(onNext: { [weak self] rating in
                self?.starRatingView.configure(with: rating)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.previewCount
            .filter { $0 != 0 }
            .drive(onNext: { [weak self] count in
                self?.previewStackView.input.itemCount.onNext(count)
            })
            .disposed(by: disposeBag)
            
    }
    
    func setConstraint() {
        
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 62),
            iconImageView.widthAnchor.constraint(equalToConstant: 62),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        [titleLabel, descLabel, starRatingView].forEach {
            labelStackView.addArrangedSubview($0)
        }
        contentView.addSubview(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            labelStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
        ])
        
        contentView.addSubview(downloadButton)
        NSLayoutConstraint.activate([
            downloadButton.widthAnchor.constraint(equalToConstant: 72),
            downloadButton.heightAnchor.constraint(equalToConstant: 26),
            downloadButton.centerYAnchor.constraint(equalTo: labelStackView.centerYAnchor),
            downloadButton.leadingAnchor.constraint(equalTo: labelStackView.trailingAnchor, constant: 4),
            downloadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        contentView.addSubview(previewStackView)
        let previewBottomAnchor = previewStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        previewBottomAnchor.priority = .defaultHigh
        NSLayoutConstraint.activate([
            previewStackView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 34),
            previewStackView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 34),
            previewStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            previewBottomAnchor
        ])
    }
}
