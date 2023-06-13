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
    
    private let dataSubject = PublishSubject<SearchAppItem>()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    func bind(viewModel: SearchAppTableViewCellViewModelType) {
        viewModel.output
            .map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output
            .compactMap { $0.icon }
            .flatMap { ImageLoader.cache_loadImage(from: $0) }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] image in
                self?.iconImageView.image = image
            })
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        iconImageView.image = nil
        disposeBag = DisposeBag()
    }
}

private extension SearchAppTableViewCell {
    
    func setConstraint() {
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 120),
            iconImageView.widthAnchor.constraint(equalToConstant: 120),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
