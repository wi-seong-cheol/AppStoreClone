//
//  SearchResultViewController.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/05.
//

import UIKit

import RxSwift

class SearchResultViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: SearchResultViewModel
    
    private var datasource: SearchResultSection = SearchResultSection.EMPTY
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 130
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator = true
        tableView.contentInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register Cell
        tableView.register(withType: SearchTermTableViewCell.self)
        tableView.register(withType: SearchAppTableViewCell.self)
        
        return tableView
    }()
    
    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
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

extension SearchResultViewController {
    
    func configure() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
    }
}

extension SearchResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch datasource.type {
        case .searchAppItem:
            break
        case .searchTerm:
            Observable.just(indexPath.row)
                .subscribe(onNext: { [weak self] index in
                    self?.viewModel.input.searchClick.onNext(index)
                })
                .disposed(by: disposeBag)
        }
    }
}

extension SearchResultViewController: UITableViewDataSource {

    // MARK: - Row Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = datasource.items[indexPath.row]
        switch datasource.type {
        case .searchAppItem:
            let cell: SearchAppTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bind(viewModel: SearchAppTableViewCellViewModel(item: item as? SearchAppItem ?? SearchAppItem()))
            cell.selectionStyle = .none
            return cell
        case .searchTerm:
            let cell: SearchTermTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bind(viewModel: SearchTermTableViewCellViewModel(item: item as? SearchTermItem ?? SearchTermItem()))
            cell.selectionStyle = .none
            return cell
        }
    }
}
