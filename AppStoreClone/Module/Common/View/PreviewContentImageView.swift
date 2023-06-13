//
//  PreviewContentImageView.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/10.
//

import UIKit

final class PreviewContentImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 10
        clipsToBounds = true
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
}
