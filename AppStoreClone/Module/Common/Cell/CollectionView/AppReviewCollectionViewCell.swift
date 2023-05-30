//
//  AppReviewCollectionViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

import RxSwift

final class AppReviewCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<ReviewItem>
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#85858A")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#85858A")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let review: UILabel = {
        let label = UILabel()
        label.text = "개발자"
        label.numberOfLines = 6
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let star1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let star2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let star3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let star4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let star5: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let starView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 2.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        let data = PublishSubject<ReviewItem>()
        onData = data.asObserver()
        super.init(frame: frame)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<ReviewItem>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                titleLabel.text = item.title
                dateLabel.text = item.date
                nicknameLabel.text = item.nickname
                review.text = item.review
            })
            .disposed(by: disposeBag)
        
        contentView.backgroundColor = UIColor(hex: "#F2F2F6")
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        starView.addArrangedSubview(star1)
        starView.addArrangedSubview(star2)
        starView.addArrangedSubview(star3)
        starView.addArrangedSubview(star4)
        starView.addArrangedSubview(star5)
        contentView.addSubview(starView)
        NSLayoutConstraint.activate([
            starView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            starView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        contentView.addSubview(nicknameLabel)
        NSLayoutConstraint.activate([
            nicknameLabel.centerYAnchor.constraint(equalTo: starView.centerYAnchor),
            nicknameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: starView.trailingAnchor, constant: 4),
            nicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        contentView.addSubview(review)
        review.setContentHuggingPriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            review.topAnchor.constraint(equalTo: starView.bottomAnchor, constant: 10),
            review.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            review.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            review.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
