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
    
    private var datasource: [SearchSection] = []
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedSectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionHeaderHeight = 70
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator = true
        tableView.contentInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register Cell
        tableView.register(withType: NewDiscoveryTableViewCell.self)
        tableView.register(withType: AppDownloadTableViewCell.self)
        
        // Register Header & Footer
        tableView.register(withType: SearchHeaderView.self)
        return tableView
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
//        guard let navigationBar = self.navigationController?.navigationBar else {
//            return
//        }
//        let searchBarHeight = searchController.searchBar.frame.height
//        navigationController?.navigationBar.addSubview(cancelButton)
//        cancelButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            cancelButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16),
//            cancelButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -searchBarHeight - 4),
//        ])
    }
    
    func setupBindings() {
        // MARK: Input
        cancelButton.rx.tap
            .subscribe(onNext: {
                print("click")
            })
            .disposed(by: disposeBag)
        
        // MARK: Output
        viewModel.output.datasource
            .drive(onNext: { [weak self] value in
                guard let self = self else { return }
                datasource = value
            })
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: SearchHeaderView = tableView.dequeueReusableHeaderFooterView()
        header.onData.onNext(datasource[section].type)
        return header
    }
}

extension SearchViewController: UITableViewDataSource {

    // MARK: - Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }

    // MARK: - Row Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = datasource[indexPath.section].items[indexPath.row]
        switch datasource[indexPath.section].type {
        case .new:
            let cell: NewDiscoveryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? NewItem ?? NewItem())
            cell.selectionStyle = .none
            return cell
        case .suggestion:
            let cell: AppDownloadTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? SuggestionItem ?? SuggestionItem())
            cell.selectionStyle = .none
            return cell
        }
    }
}
