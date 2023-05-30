//
//  AppDeveloperCollectionViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

import RxSwift

final class AppDeveloperCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<DeveloperItem>
    
    private let developerID: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemBlue
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let developer: UILabel = {
        let label = UILabel()
        label.text = "개발자"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let more: UIImageView = {
        let imageView = UIImageView()
        imageView.image?.withTintColor(UIColor.black)
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        let data = PublishSubject<DeveloperItem>()
        onData = data.asObserver()
        super.init(frame: frame)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<DeveloperItem>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                developerID.text = item.developerID
            })
            .disposed(by: disposeBag)
        
        stackView.addArrangedSubview(developerID)
        stackView.addArrangedSubview(developer)
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        contentView.addSubview(more)
        NSLayoutConstraint.activate([
            more.centerYAnchor.constraint(equalTo: centerYAnchor),
            more.leadingAnchor.constraint(greaterThanOrEqualTo: stackView.trailingAnchor, constant: 4),
            more.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
