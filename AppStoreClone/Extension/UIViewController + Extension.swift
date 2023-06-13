//
//  UIViewController + Extension.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/04.
//

import UIKit

extension UIViewController {
    
    func alert(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.view.tintColor = .black
        actions.forEach {
            alertController.addAction($0)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirmAlert(_ message: String) {
        DispatchQueue.main.async {
            let localizedMessage = NSLocalizedString(message, comment: "Alert message")
            let actions = [
                UIAlertAction(title: NSLocalizedString("확인", comment: "Alert OK"),
                              style: .default,
                              handler: nil)
            ]
            self.alert(title: "", message: localizedMessage, actions: actions)
        }
    }
}
