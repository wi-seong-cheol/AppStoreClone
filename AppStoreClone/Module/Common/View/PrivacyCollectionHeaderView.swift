//
//  PrivacyCollectionHeaderView.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/29.
//

import UIKit

import RxSwift

final class PrivacyCollectionHeaderView: UICollectionReusableView {
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#CDCDCE")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var mainText: UILabel = {
        var label = UILabel()
        label.text = "앱 개인 정보 보호"
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var desc: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.systemGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var headerButton: UIButton = {
        var button = UIButton()
        button.setTitle("세부사항 보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.link, for: .normal)
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .trailing
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<String>
    
    override init(frame: CGRect) {
        let data = PublishSubject<String>()
        onData = data.asObserver()
        super.init(frame: frame)
        setup(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(data: PublishSubject<String>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] developerID in
                guard let self = self else { return }
                desc.text = "\(developerID) 개발자가 아래 설명되 데이터 처리 방식이 앱의 개인정보 처리방침에 포함되어 있을 수 있다고 표시했습니다. 자세한 내용은 개발자의 개인정보 처리방침을 참조하십시오."
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
        
        addSubview(desc)
        NSLayoutConstraint.activate([
            desc.topAnchor.constraint(equalTo: mainText.bottomAnchor, constant: 10),
            desc.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            desc.leadingAnchor.constraint(equalTo: leadingAnchor),
            desc.trailingAnchor.constraint(equalTo: trailingAnchor)
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
    }
}
