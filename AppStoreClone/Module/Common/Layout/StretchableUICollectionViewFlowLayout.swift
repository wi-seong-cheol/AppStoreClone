//
//  StretchableUICollectionViewFlowLayout.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import UIKit

final class StretchableUICollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        guard let offset = collectionView?.contentOffset, let stLayoutAttributes = layoutAttributes else {
            return layoutAttributes
        }
        
        if offset.y < 0 {
            for attributes in stLayoutAttributes where attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                let diffValue = abs(offset.y)
                var frame = attributes.frame
                frame.size.height = max(0, headerReferenceSize.height + diffValue)
                frame.origin.y = frame.minY - diffValue
                attributes.frame = frame
            }
        }
        return layoutAttributes
    }
}
