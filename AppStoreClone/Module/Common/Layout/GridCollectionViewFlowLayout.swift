//
//  GridCollectionViewFlowLayout.swift
//  BoilerPlate
//
//  Created by wi_seong on 2023/05/18.
//

import UIKit

final class GridCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var ratioHeightToWidth = 1.0
    var numberOfColumns = 1
    
    var cellSpacing = 0.0 {
        didSet {
            self.minimumLineSpacing = self.cellSpacing
            self.minimumInteritemSpacing = self.cellSpacing
        }
    }
    
    override init() {
        super.init()
        self.scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
