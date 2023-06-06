//
//  AppFeatureCollectionViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

import RxSwift

final class AppFeatureCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<FeatureItem>
    
    private let version: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let date: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let content: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let more: UIButton = {
        let button = UIButton()
        button.setTitle("더 보기", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        let data = PublishSubject<FeatureItem>()
        onData = data.asObserver()
        super.init(frame: frame)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<FeatureItem>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                self?.version.text = item.version
                self?.date.text = item.date
                self?.content.text = item.content
            })
            .disposed(by: disposeBag)
        
        contentView.addSubview(version)
        NSLayoutConstraint.activate([
            version.topAnchor.constraint(equalTo: topAnchor),
            version.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        contentView.addSubview(date)
        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: topAnchor),
            date.leadingAnchor.constraint(greaterThanOrEqualTo: version.trailingAnchor, constant: 4),
            date.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        contentView.addSubview(content)
        content.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 10),
            content.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        contentView.addSubview(more)
        NSLayoutConstraint.activate([
            more.widthAnchor.constraint(equalToConstant: 60),
            more.heightAnchor.constraint(equalToConstant: 20),
            more.bottomAnchor.constraint(equalTo: content.bottomAnchor),
            more.leadingAnchor.constraint(equalTo: content.trailingAnchor),
            more.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
