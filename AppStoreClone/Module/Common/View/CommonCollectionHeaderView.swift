//
//  CommonCollectionHeaderView.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

import RxSwift

final class CommonCollectionHeaderView: UICollectionReusableView {
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#CDCDCE")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var mainText: UILabel = {
        var label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var headerButton: UIButton = {
        var button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.link, for: .normal)
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .trailing
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<DetailItemType>
    
    override init(frame: CGRect) {
        let data = PublishSubject<DetailItemType>()
        onData = data.asObserver()
        super.init(frame: frame)
        setup(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(data: PublishSubject<DetailItemType>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] type in
                guard let self = self else { return }
                switch type {
                case .event:
                    mainText.text = "이벤트"
                case .evauation:
                    mainText.text = "평가 및 리뷰"
                    headerButton.setTitle("모두 보기", for: .normal)
                case .feature:
                    mainText.text = "새로운 기능"
                    headerButton.setTitle("버전 기록", for: .normal)
                case .info:
                    mainText.text = "정보"
                    headerButton.setTitle("모두 보기", for: .normal)
                case .likable:
                    mainText.text = "좋아할 만한 다른 항목"
                    headerButton.setTitle("모두 보기", for: .normal)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: topAnchor),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.2)
        ])
        
        addSubview(mainText)
        NSLayoutConstraint.activate([
            mainText.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12),
            mainText.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        addSubview(headerButton)
        NSLayoutConstraint.activate([
            headerButton.widthAnchor.constraint(equalToConstant: 100),
            headerButton.centerYAnchor.constraint(equalTo: mainText.centerYAnchor),
            headerButton.leadingAnchor.constraint(equalTo: mainText.trailingAnchor, constant: 10),
            headerButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainText.text = nil
        headerButton.setTitle(nil, for: .normal)
    }
}
