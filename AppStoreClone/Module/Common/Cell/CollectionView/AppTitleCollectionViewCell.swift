//
//  AppTitleCollectionViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

import RxSwift

final class AppTitleCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let onData: AnyObserver<TitleItem>
    
    private let thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let subText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#97979A")
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let download: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("받기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let paymentType: UILabel = {
        let label = UILabel()
        label.text = "앱 내 구입"
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let share: UIButton = {
        let button = UIButton()
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        let data = PublishSubject<TitleItem>()
        onData = data.asObserver()
        super.init(frame: frame)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<TitleItem>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.titleText.text = item.title
                self.subText.text = item.subTitle
                
                guard let url = item.thumbNail else { return }
                ImageLoader.cache_loadImage(url: url)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] image in
                        guard let self = self else { return }
                        self.thumbnail.image = image
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        contentView.addSubview(thumbnail)
        NSLayoutConstraint.activate([
            thumbnail.heightAnchor.constraint(equalToConstant: 120),
            thumbnail.widthAnchor.constraint(equalToConstant: 120),
            thumbnail.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            thumbnail.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        contentView.addSubview(titleText)
        NSLayoutConstraint.activate([
            titleText.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleText.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 16),
            titleText.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        contentView.addSubview(subText)
        NSLayoutConstraint.activate([
            subText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 2),
            subText.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 16),
            subText.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        contentView.addSubview(download)
        NSLayoutConstraint.activate([
            download.widthAnchor.constraint(equalToConstant: 70),
            download.heightAnchor.constraint(equalToConstant: 30),
            download.topAnchor.constraint(greaterThanOrEqualTo: subText.bottomAnchor, constant: 4),
            download.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            download.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 16)
        ])

        contentView.addSubview(paymentType)
        NSLayoutConstraint.activate([
            paymentType.centerYAnchor.constraint(equalTo: download.centerYAnchor),
            paymentType.leadingAnchor.constraint(equalTo: download.trailingAnchor, constant: 8)
        ])

        contentView.addSubview(share)
        NSLayoutConstraint.activate([
            share.widthAnchor.constraint(equalToConstant: 22),
            share.heightAnchor.constraint(equalToConstant: 26),
            share.centerYAnchor.constraint(equalTo: paymentType.centerYAnchor),
            share.leadingAnchor.constraint(greaterThanOrEqualTo: paymentType.trailingAnchor, constant: 4),
            share.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
