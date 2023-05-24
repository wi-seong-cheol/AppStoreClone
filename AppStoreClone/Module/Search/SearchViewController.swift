//
//  SearchViewController.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import UIKit

import RxSwift

class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "게임, 앱, 스토리 등"
        return searchBar
    }()
    private let tableView: UITableView = {
        let view = UITableView()
        return view
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

extension SearchViewController {
    
    func configure() {
        view.backgroundColor = .white
        
        self.navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.titleView = searchBar
        
        let rightButton = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = rightButton
        
        [
            tableView
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            
        ])
    }
    
    func setupBindings() {
        // MARK: Input
        
        // MARK: Output
    }
}
