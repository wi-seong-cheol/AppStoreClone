//
//  NewDiscoveryTableViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/24.
//

import UIKit

import RxRelay
import RxSwift

class NewDiscoveryTableViewCell: UITableViewCell {
    
    private let cellDisposeBag = DisposeBag()
    private var disposeBag = DisposeBag()
    
    let onData: AnyObserver<NewItem>
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#D4D4D5", alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemBlue
        label.font = UIFont.systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let data = PublishSubject<NewItem>()
        onData = data.asObserver()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<NewItem>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.titleText.text = item.title
            })
            .disposed(by: cellDisposeBag)
        
        contentView.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.2)
        ])
        
        contentView.addSubview(titleText)
        NSLayoutConstraint.activate([
            titleText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleText.topAnchor.constraint(equalTo: separatorView.topAnchor, constant: 10),
            titleText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
