//
//  SearchHeaderView.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/24.
//

import UIKit

import RxSwift

final class SearchHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "SearchHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cellDisposeBag = DisposeBag()
    private var disposeBag = DisposeBag()
    
    let onData: AnyObserver<String>
    
    override init(reuseIdentifier: String?) {
        let data = PublishSubject<String>()
        onData = data.asObserver()
        super.init(reuseIdentifier: reuseIdentifier)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<String>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                self.titleLabel.text = title
            })
            .disposed(by: cellDisposeBag)
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
