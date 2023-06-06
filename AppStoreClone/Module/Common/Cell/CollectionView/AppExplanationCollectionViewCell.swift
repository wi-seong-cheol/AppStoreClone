//
//  AppExplanationCollectionViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

import RxSwift

final class AppExplanationCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<ExplanationItem>
    
    private let firstContent: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let secondContent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let more: UILabel = {
        let label = UILabel()
        label.text = "더 보기"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = UIColor.systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        let data = PublishSubject<ExplanationItem>()
        onData = data.asObserver()
        super.init(frame: frame)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<ExplanationItem>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                self?.firstContent.text = item.description
                self?.secondContent.text = item.description
            })
            .disposed(by: disposeBag)
        
        contentView.addSubview(firstContent)
        NSLayoutConstraint.activate([
            firstContent.topAnchor.constraint(equalTo: topAnchor),
            firstContent.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstContent.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        contentView.addSubview(secondContent)
        secondContent.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            secondContent.topAnchor.constraint(equalTo: firstContent.bottomAnchor),
            secondContent.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        contentView.addSubview(more)
        NSLayoutConstraint.activate([
            more.centerYAnchor.constraint(equalTo: secondContent.centerYAnchor),
            more.leadingAnchor.constraint(equalTo: secondContent.trailingAnchor, constant: 4),
            more.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
