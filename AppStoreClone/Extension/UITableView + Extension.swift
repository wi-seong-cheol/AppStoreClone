//
//  UITableView + Extension.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/28.
//

import Foundation
import UIKit

extension UITableView {
    
    func register(withType type: UITableViewCell.Type,
                      withReuseIdentifier identifier: String? = nil) {
        let cellId = identifier ?? String(describing: type)
        register(type, forCellReuseIdentifier: cellId)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
    
    func register(withType type: UITableViewHeaderFooterView.Type,
                      withReuseIdentifier identifier: String? = nil) {
        let cellId = identifier ?? String(describing: type)
        register(type, forHeaderFooterViewReuseIdentifier: cellId)
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
}

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    
    static var identifier: String {
        return String(describing: self)
    }
}
