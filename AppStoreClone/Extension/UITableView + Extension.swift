//
//  UITableView + Extension.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/28.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = identifier ?? String(describing: type)
        register(type, forCellReuseIdentifier: cellId)
    }
    
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.identifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(type.identifier)")
        }
        return cell
    }
    
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(type.identifier)")
        }
        return cell
    }
}

public extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
}
