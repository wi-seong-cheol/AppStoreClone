//
//  AppBriefInfoCollectionViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

import RxSwift

final class AppBriefInfoCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<BriefInfoItem>
    
    private let titleText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#B1B1B4")
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var firstContent: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#8E8E92")
        label.font = UIFont.systemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var secondContent: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#8E8E92")
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var developerIcon: UIImageView = {
        let size = UIFont.systemFont(ofSize: 26).lineHeight
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        imageView.image = UIImage(systemName: "person.crop.square")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var starIcon: UIImage = {
        let image = UIImage()
//        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        let data = PublishSubject<BriefInfoItem>()
        onData = data.asObserver()
        super.init(frame: frame)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<BriefInfoItem>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                switch item.type {
                case let .grade(data):
                    self.titleText.text = "\(data.total)만 개의 평가"
                    self.firstContent.text = "\(data.score)"
                    self.secondContent.text = "1223"
                    stackView.addArrangedSubview(titleText)
                    stackView.addArrangedSubview(firstContent)
                    stackView.addArrangedSubview(secondContent)
                case let .age(data):
                    self.titleText.text = "연령"
                    self.firstContent.text = data.age
                    self.secondContent.text = "세"
                    stackView.addArrangedSubview(titleText)
                    stackView.addArrangedSubview(firstContent)
                    stackView.addArrangedSubview(secondContent)
                case let .chart(data):
                    self.titleText.text = "차트"
                    self.firstContent.text = "#\(data.rank)"
                    self.secondContent.text = data.type
                    stackView.addArrangedSubview(titleText)
                    stackView.addArrangedSubview(firstContent)
                    stackView.addArrangedSubview(secondContent)
                case let .developer(data):
                    self.titleText.text = "개발자"
                    self.secondContent.text = data.id
                    stackView.addArrangedSubview(titleText)
                    stackView.addArrangedSubview(developerIcon)
                    stackView.addArrangedSubview(secondContent)
                case let .language(data):
                    self.titleText.text = "언어"
                    self.firstContent.text = data.language
                    self.secondContent.text = "+ \(data.total)개 언어"
                    stackView.addArrangedSubview(titleText)
                    stackView.addArrangedSubview(firstContent)
                    stackView.addArrangedSubview(secondContent)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
