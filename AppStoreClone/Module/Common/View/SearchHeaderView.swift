//
//  SearchHeaderView.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/24.
//

import UIKit

import RxSwift

final class SearchHeaderView: UITableViewHeaderFooterView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var disposeBag = DisposeBag()
    let onData: AnyObserver<SearchItemType>
    
    override init(reuseIdentifier: String?) {
        let data = PublishSubject<SearchItemType>()
        onData = data.asObserver()
        super.init(reuseIdentifier: reuseIdentifier)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<SearchItemType>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] type in
                switch type {
                case .new:
                    self?.titleLabel.text = "새로운 발견"
                case .recommend:
                    self?.titleLabel.text = "추천 앱과 게임"
                }
            })
            .disposed(by: disposeBag)
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
