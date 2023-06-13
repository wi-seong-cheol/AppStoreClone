//
//  AppEventCollectionViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

import RxSwift

final class AppEventCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<EventItem>
    private let loadImage: PublishSubject<String?>
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        let data = PublishSubject<EventItem>()
        let load = PublishSubject<String?>()
        onData = data.asObserver()
        loadImage = load.asObserver()
        super.init(frame: frame)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<EventItem>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                self?.timeLabel.text = item.time
                self?.loadImage.onNext(item.thumbnail)
            })
            .disposed(by: disposeBag)
        
        loadImage
            .compactMap { $0 }
            .flatMap { ImageLoader.cache_loadImage(from: $0) }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.thumbnail.image = image
            })
            .disposed(by: disposeBag)
        
        contentView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        contentView.addSubview(thumbnail)
        NSLayoutConstraint.activate([
            thumbnail.heightAnchor.constraint(equalTo: thumbnail.widthAnchor, multiplier: 0.6),
            thumbnail.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
