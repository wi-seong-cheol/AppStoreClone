//
//  PreviewStackView.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/08.
//

import UIKit

import RxSwift
import RxCocoa

typealias PreviewStackViewInput = (images: AnyObserver<[UIImage]>,
                                   itemCount: AnyObserver<Int>)

protocol PreviewStackViewType {
    var input: PreviewStackViewInput { get }
}

final class PreviewStackView: UIStackView, PreviewStackViewType {
    
    private var disposedBag = DisposeBag()
    
    private let horizontalModeHeight: CGFloat = 228 / 406
    private let verticalModeHeight: CGFloat = 696 / 392
    
    private let images = PublishSubject<[UIImage]>()
    private let itemCount = PublishSubject<Int>()
    
    var input: PreviewStackViewInput {
        return (images.asObserver(),
                itemCount.asObserver())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        bind()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        itemCount
            .subscribe(onNext: { [unowned self] count in
                let innerSpace: CGFloat = CGFloat(10 * (count - 1))
                let spaceOnBothSides: CGFloat = 20 * 2
                let isSingle: Bool = count == 1
                let width = (UIScreen.main.bounds.width - spaceOnBothSides - innerSpace) / (isSingle ? 1 : 3)
                let height = width * (isSingle ? self.horizontalModeHeight : self.verticalModeHeight)
                
                subviews.forEach { $0.removeFromSuperview() }
                for index in 0 ..< count {
                    let imageView = PreviewContentImageView(frame: .init())
                    images
                        .filter { index < $0.count }
                        .map { $0[index] }
                        .bind(to: imageView.rx.image)
                        .disposed(by: disposedBag)
                    
                    NSLayoutConstraint.activate([
                        imageView.widthAnchor.constraint(equalToConstant: width),
                        imageView.heightAnchor.constraint(equalToConstant: height)
                    ])
                    
                    addArrangedSubview(imageView)
                }
            })
            .disposed(by: disposedBag)
    }
}

private extension PreviewStackView {

    func configure() {
        distribution = .fillProportionally
        axis = .horizontal
        spacing = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
}
