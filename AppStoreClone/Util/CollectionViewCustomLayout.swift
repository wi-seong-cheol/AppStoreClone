//
//  CollectionViewCustomLayout.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/28.
//

import UIKit

protocol CollectionViewCustomLayout {
    func createTitleSection(_ rect: CGRect)         -> NSCollectionLayoutSection
    func createBriefInfoSection(_ rect: CGRect)     -> NSCollectionLayoutSection
    func createPreviewSection(_ rect: CGRect)       -> NSCollectionLayoutSection
    func createExplanationSection(_ rect: CGRect)   -> NSCollectionLayoutSection
    func createDeveloperSection(_ rect: CGRect)     -> NSCollectionLayoutSection
    func createEventSection(_ rect: CGRect)         -> NSCollectionLayoutSection
    func createEvaluationSection(_ rect: CGRect)    -> NSCollectionLayoutSection
    func createReviewSection(_ rect: CGRect)        -> NSCollectionLayoutSection
    func createFeatureSection(_ rect: CGRect)       -> NSCollectionLayoutSection
    func createPrivacySection(_ rect: CGRect)       -> NSCollectionLayoutSection
    func createInfoSection(_ rect: CGRect)          -> NSCollectionLayoutSection
    func createSupportSection(_ rect: CGRect)       -> NSCollectionLayoutSection
    func createRelationSection(_ rect: CGRect)      -> NSCollectionLayoutSection
    func createLikableSection(_ rect: CGRect)       -> NSCollectionLayoutSection
    func createItemSectionHeader()                  -> NSCollectionLayoutBoundarySupplementaryItem
}

extension CollectionViewCustomLayout {
    
    func createTitleSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 20
        let groupMargin: CGFloat = 0
        
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width - (sectionMargin * 2)),
            heightDimension: .estimated(152)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: groupMargin, leading: groupMargin, bottom: groupMargin, trailing: groupMargin)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: sectionMargin, bottom: 10, trailing: sectionMargin)
        
        return section
    }
    
    func createBriefInfoSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 0
        let groupMargin: CGFloat = 20

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width * 1.6),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: sectionMargin, leading: sectionMargin, bottom: sectionMargin, trailing: sectionMargin)
        
        return section
    }

    func createPreviewSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 20
        let groupMargin: CGFloat = 4

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width * 0.6),
            heightDimension: .absolute((rect.width * 0.6) * 2.17)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: sectionMargin, leading: sectionMargin - groupMargin, bottom: sectionMargin, trailing: sectionMargin - groupMargin)

        let sectionHeader = createItemSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createExplanationSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 20
        let groupMargin: CGFloat = 0

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let labelHeight = UIFont.systemFont(ofSize: 14).lineHeight
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width - sectionMargin * 2),
            heightDimension: .estimated(labelHeight * 3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: sectionMargin - groupMargin, bottom: sectionMargin, trailing: sectionMargin - groupMargin)

        let sectionHeader = createItemSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createDeveloperSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 10
        let groupMargin: CGFloat = 20

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let labelHeight = UIFont.systemFont(ofSize: 14).lineHeight
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width),
            heightDimension: .estimated(labelHeight * 3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: sectionMargin, leading: 0, bottom: sectionMargin, trailing: 0)

        return section
    }

    func createEventSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 20
        let groupMargin: CGFloat = 0

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width - sectionMargin * 2),
            heightDimension: .estimated((rect.width - groupMargin * 2) * 0.6 + 20)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: sectionMargin, leading: sectionMargin - groupMargin, bottom: sectionMargin, trailing: sectionMargin - groupMargin)

        let sectionHeader = createItemSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createEvaluationSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 20
        let groupMargin: CGFloat = 0

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let labelHeight = UIFont.systemFont(ofSize: 14).lineHeight
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width - sectionMargin * 2),
            heightDimension: .estimated(labelHeight * 3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: sectionMargin, leading: sectionMargin - groupMargin, bottom: sectionMargin, trailing: sectionMargin - groupMargin)

        let sectionHeader = createItemSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createReviewSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 20
        let groupMargin: CGFloat = 5

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let labelHeight = UIFont.systemFont(ofSize: 14).lineHeight
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width - sectionMargin * 2 + groupMargin * 2),
            heightDimension: .estimated(labelHeight * 8 + 38)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: sectionMargin, leading: sectionMargin - groupMargin, bottom: sectionMargin, trailing: sectionMargin - groupMargin)

        return section
    }

    func createFeatureSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 20
        let groupMargin: CGFloat = 0

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let labelHeight = UIFont.systemFont(ofSize: 14).lineHeight
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width - sectionMargin * 2),
            heightDimension: .estimated(labelHeight * 4 + 30)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: sectionMargin, leading: sectionMargin - groupMargin, bottom: sectionMargin, trailing: sectionMargin - groupMargin)

        let sectionHeader = createItemSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createPrivacySection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 20
        let groupMargin: CGFloat = 20

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(20), trailing: nil, bottom: nil)

        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width - groupMargin * 2),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 0, leading: sectionMargin, bottom: sectionMargin, trailing: sectionMargin)

        let sectionHeader = createItemSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createInfoSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 10
        let groupMargin: CGFloat = 20

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let labelHeight = UIFont.systemFont(ofSize: 14).lineHeight
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width),
            heightDimension: .estimated(labelHeight * 3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: sectionMargin, leading: 0, bottom: sectionMargin, trailing: 0)

        let sectionHeader = createItemSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createSupportSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 10
        let groupMargin: CGFloat = 20

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let labelHeight = UIFont.systemFont(ofSize: 14).lineHeight
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width),
            heightDimension: .estimated(labelHeight * 3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: sectionMargin, leading: 0, bottom: sectionMargin, trailing: 0)

        let sectionHeader = createItemSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createRelationSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 10
        let groupMargin: CGFloat = 20

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let labelHeight = UIFont.systemFont(ofSize: 14).lineHeight
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width),
            heightDimension: .estimated(labelHeight * 3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: sectionMargin, leading: 0, bottom: sectionMargin, trailing: 0)

        let sectionHeader = createItemSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createLikableSection(_ rect: CGRect) -> NSCollectionLayoutSection {
        let sectionMargin: CGFloat = 10
        let groupMargin: CGFloat = 20

        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let labelHeight = UIFont.systemFont(ofSize: 14).lineHeight
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(rect.width),
            heightDimension: .estimated(labelHeight * 3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: groupMargin, bottom: 0, trailing: groupMargin)

        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: sectionMargin, leading: 0, bottom: sectionMargin, trailing: 0)

        let sectionHeader = createItemSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createItemSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        //section header 사이즈
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))

        //section header Layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        return sectionHeader
     }
}
