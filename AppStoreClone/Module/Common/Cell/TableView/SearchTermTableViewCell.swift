//
//  SearchTermTableViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/04.
//

import UIKit

import RxRelay
import RxSwift

class SearchTermTableViewCell: UITableViewCell {
    
    private var disposeBag = DisposeBag()
    
    private let searchTerm: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(viewModel: SearchTermTableViewCellViewModelType) {
        viewModel.output
            .map { $0.searchTerm }
            .bind(to: searchTerm.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchTerm.text = nil
        disposeBag = DisposeBag()
    }
}

private extension SearchTermTableViewCell {
    
    func setConstraint() {
        contentView.addSubview(searchTerm)
        NSLayoutConstraint.activate([
            searchTerm.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            searchTerm.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            searchTerm.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchTerm.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
