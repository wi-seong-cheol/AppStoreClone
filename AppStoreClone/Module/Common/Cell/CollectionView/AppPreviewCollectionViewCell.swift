//
//  AppPreviewCollectionViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

import RxSwift

final class AppPreviewCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<PreviewItem>
    
    private let content: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        let data = PublishSubject<PreviewItem>()
        onData = data.asObserver()
        super.init(frame: frame)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<PreviewItem>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                switch item.content {
                case let .photo(data):
                    ImageLoader.cache_loadImage(url: data.url)
                        .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { [weak self] image in
                            guard let self = self else { return }
                            self.content.image = image
                        })
                        .disposed(by: disposeBag)
                case let .video(video):
                    // Preview 비디오 타입 코드 작성
                    break
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        contentView.addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
