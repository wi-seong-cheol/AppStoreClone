//
//  TodayViewController.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import UIKit

import RxSwift

class TodayViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = TodayViewModel()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = "Small Title"
        label.backgroundColor = UIColor.clear
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .blue
        return label
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TodayViewController {
    
    func configure() {
        view.backgroundColor = .white
    }
    
    func setupBindings() {
        // MARK: Input
        
        // MARK: Output
    }
}
