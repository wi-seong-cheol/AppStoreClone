//
//  AppDownloadTableViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/25.
//

import UIKit

import RxRelay
import RxSwift

class AppDownloadTableViewCell: UITableViewCell {
    
    private let cellDisposeBag = DisposeBag()
    private var disposeBag = DisposeBag()
    
    let onData: AnyObserver<SuggestionItem>
    
    private let appIcon: UIImageView = {
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
    private let category: UILabel = {
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
        let data = PublishSubject<SuggestionItem>()
        onData = data.asObserver()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<SuggestionItem>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.titleText.text = item.title
                self.category.text = item.desc
                guard let url = item.appIcon else { return }
                ImageLoader.cache_loadImage(url: url)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] image in
                        guard let self = self else { return }
                        self.appIcon.image = image
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: cellDisposeBag)
        
        contentView.addSubview(appIcon)
        NSLayoutConstraint.activate([
            appIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            appIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            appIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            appIcon.heightAnchor.constraint(equalToConstant: 60),
            appIcon.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        textStackView.addArrangedSubview(titleText)
        textStackView.addArrangedSubview(category)
        contentView.addSubview(textStackView)
        NSLayoutConstraint.activate([
            textStackView.leadingAnchor.constraint(equalTo: appIcon.trailingAnchor, constant: 20),
            textStackView.centerYAnchor.constraint(equalTo: appIcon.centerYAnchor)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
