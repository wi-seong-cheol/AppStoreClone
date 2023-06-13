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
    private let relatedSearchViewModel = SearchResultViewModel()
    
    private var datasource: [SearchSection] = []
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultViewController(viewModel: relatedSearchViewModel))
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.keyboardDismissMode = .onDrag
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
    private let searchBar = UISearchBar()
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SearchViewController {
    
    func configure() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.largeTitleDisplayMode = .automatic
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
    }
    
    func setupBindings() {
        // MARK: Input
        Observable.just(())
            .bind(to: viewModel.input.fetch)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
            .bind(to: relatedSearchViewModel.input.searchText)
            .disposed(by: disposeBag)
        
        // MARK: Output
        viewModel.output.datasource
            .drive(onNext: { [weak self] value in
                self?.datasource = value
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .subscribe(onNext: { [weak self] message in
                self?.confirmAlert(message)
            })
            .disposed(by: disposeBag)
        
        relatedSearchViewModel.output.updateSearchText
            .bind(to: searchController.searchBar.rx.text)
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch datasource[indexPath.section].type {
        case .new:
            print(datasource[indexPath.section].items)
        case .recommend:
            viewModel.output.appData
                .drive(onNext: { [weak self] data in
                    let vc = DetailViewController(viewModel: DetailViewModel(data: data[indexPath.row]))
                    self?.navigationController?.pushViewController(vc, animated: true)
                })
                .disposed(by: disposeBag)
        }
    }

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
        case .recommend:
            let cell: AppDownloadTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? RecommendItem ?? RecommendItem())
            cell.selectionStyle = .none
            return cell
        }
    }
}
