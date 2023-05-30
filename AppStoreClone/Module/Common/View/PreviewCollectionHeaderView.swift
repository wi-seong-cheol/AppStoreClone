//
//  PreviewCollectionHeaderView.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/29.
//

import UIKit

import RxSwift

final class PreviewCollectionHeaderView: UICollectionReusableView {
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#CDCDCE")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var mainText: UILabel = {
        var label = UILabel()
        label.text = "미리보기"
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: topAnchor),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            lineView.heightAnchor.constraint(equalToConstant: 0.2)
        ])
        
        addSubview(mainText)
        NSLayoutConstraint.activate([
            mainText.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12),
            mainText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            mainText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            mainText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
