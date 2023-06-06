//
//  AppEvaluationCollectionViewCell.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

import RxSwift

final class AppEvaluationCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<EvaluationItem>
    
    private let grade: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let maxGrade: UILabel = {
        let label = UILabel()
        label.text = "(최고 5점)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let scoreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let total: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        let data = PublishSubject<EvaluationItem>()
        onData = data.asObserver()
        super.init(frame: frame)
        setup(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(data: PublishSubject<EvaluationItem>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let grade = item.grade else { return }
                self?.grade.text = String(format: "%.1f", grade)
                
            })
            .disposed(by: disposeBag)
        
        scoreStackView.addArrangedSubview(grade)
        scoreStackView.addArrangedSubview(maxGrade)
        contentView.addSubview(scoreStackView)
        NSLayoutConstraint.activate([
            scoreStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scoreStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
