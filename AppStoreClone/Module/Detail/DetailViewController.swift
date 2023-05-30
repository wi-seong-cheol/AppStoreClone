//
//  DetailViewController.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

import RxSwift

final class DetailViewController: UIViewController, CollectionViewCustomLayout {
    
    private let disposeBag = DisposeBag()
    private let viewModel = DetailViewModel()
    private var datasource: [DetailSection] = []
    
    private lazy var collectionView: UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register Cell
        collectionView.register(withType: AppTitleCollectionViewCell.self)
        collectionView.register(withType: AppBriefInfoCollectionViewCell.self)
        collectionView.register(withType: AppPreviewCollectionViewCell.self)
        collectionView.register(withType: AppExplanationCollectionViewCell.self)
        collectionView.register(withType: AppDeveloperCollectionViewCell.self)
        collectionView.register(withType: AppEventCollectionViewCell.self)
        collectionView.register(withType: AppEvaluationCollectionViewCell.self)
        collectionView.register(withType: AppReviewCollectionViewCell.self)
        collectionView.register(withType: AppFeatureCollectionViewCell.self)
        collectionView.register(withType: AppPrivacyCollectionViewCell.self)
        collectionView.register(withType: AppInfoCollectionViewCell.self)
        collectionView.register(withType: AppSupportCollectionViewCell.self)
        collectionView.register(withType: AppRelationCollectionViewCell.self)
        collectionView.register(withType: AppLikableCollectionViewCell.self)
        
        // Register Header
        collectionView.register(withType: ImageHeaderView.self)
        collectionView.register(withType: CommonCollectionHeaderView.self)
        collectionView.register(withType: PreviewCollectionHeaderView.self)
        collectionView.register(withType: PrivacyCollectionHeaderView.self)
        
        return collectionView
    }()
    private lazy var collectionViewFlowLayout: UICollectionViewLayout = {
        return UICollectionViewCompositionalLayout { [weak self] section, _ -> NSCollectionLayoutSection? in
            guard let sectionType = self?.datasource[section].type,
                  let rect = self?.view.frame else {
                return nil
            }
            switch sectionType {
            case .title:
                return self?.createTitleSection(rect)
            case .briefInfo:
                return self?.createBriefInfoSection(rect)
            case .preview:
                return self?.createPreviewSection(rect)
            case .explanation:
                return self?.createExplanationSection(rect)
            case .developer:
                return self?.createDeveloperSection(rect)
            case .event:
                return self?.createEventSection(rect)
            case .evauation:
                return self?.createEvaluationSection(rect)
            case .review:
                return self?.createReviewSection(rect)
            case .feature:
                return self?.createFeatureSection(rect)
            case .privacy:
                return self?.createPrivacySection(rect)
            case .info:
                return self?.createInfoSection(rect)
            case .support:
                return self?.createSupportSection(rect)
            case .relation:
                return self?.createRelationSection(rect)
            case .likable:
                return self?.createLikableSection(rect)
            }
        }
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
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DetailViewController {
    
    func configure() {
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupBindings() {
        
        // MARK: - INPUT
        
        // MARK: - OUTPUT
        viewModel.output.datasource
            .drive(onNext: { [weak self] value in
                guard let self = self else { return }
                self.datasource = value
            })
            .disposed(by: disposeBag)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = datasource[section]
        return section.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = datasource[indexPath.section].items[indexPath.row]
        switch datasource[indexPath.section].type {
        case .title:
            let cell: AppTitleCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? TitleItem ?? TitleItem())
            return cell
        case .briefInfo:
            let cell: AppBriefInfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? BriefInfoItem ?? BriefInfoItem.EMPTY)
            return cell
        case .preview:
            let cell: AppPreviewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? PreviewItem ?? PreviewItem.EMPTY)
            return cell
        case .explanation:
            let cell: AppExplanationCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? ExplanationItem ?? ExplanationItem())
            return cell
        case .developer:
            let cell: AppDeveloperCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? DeveloperItem ?? DeveloperItem())
            return cell
        case .event:
            let cell: AppEventCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? EventItem ?? EventItem())
            return cell
        case .evauation:
            let cell: AppEvaluationCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? EvaluationItem ?? EvaluationItem())
            return cell
        case .review:
            let cell: AppReviewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? ReviewItem ?? ReviewItem())
            return cell
        case .feature:
            let cell: AppFeatureCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? FeatureItem ?? FeatureItem())
            return cell
        case .privacy:
            let cell: AppPrivacyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            let item = datasource[indexPath.section].items[indexPath.row] as? PrivacyItem ?? PrivacyItem()
            cell.onData.onNext(item)
            return cell
        case .info:
            let cell: AppInfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? InfoItem ?? InfoItem())
            return cell
        case .support:
            let cell: AppSupportCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? SupportItem ?? SupportItem())
            return cell
        case .relation:
            let cell: AppRelationCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? RelationItem ?? RelationItem())
            return cell
        case .likable:
            let cell: AppLikableCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.onData.onNext(item as? LikableItem ?? LikableItem())
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch datasource[indexPath.section].type {
        case .title:
            let cell: AppTitleCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .briefInfo:
            let cell: AppBriefInfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .preview:
            let cell: AppPreviewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .explanation:
            let cell: AppExplanationCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .developer:
            let cell: AppDeveloperCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .event:
            let cell: AppEventCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .evauation:
            let cell: AppEvaluationCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .review:
            let cell: AppReviewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .feature:
            let cell: AppFeatureCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .privacy:
            let cell: AppPrivacyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .info:
            let cell: AppInfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .support:
            let cell: AppSupportCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .relation:
            let cell: AppRelationCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        case .likable:
            let cell: AppLikableCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.disposeBag = DisposeBag()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch datasource[indexPath.section].type {
            case .title:
                return UICollectionReusableView()
            case .privacy:
                let headerView: PrivacyCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(for: indexPath)
                headerView.onData.onNext("DeveloperID")
                return headerView
            default:
                let headerView: CommonCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(for: indexPath)
                headerView.onData.onNext(datasource[indexPath.section].type)
                return headerView
            }
        default:
#if DEBUG
            assert(false, "Don't use this kind.")
#else
            return UICollectionReusableView()
#endif
            
        }
    }
}
