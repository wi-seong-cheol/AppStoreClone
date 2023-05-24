//
//  GlobalAlert.swift
//  BoilerPlate
//
//  Created by wi_seong on 2023/05/18.
//

import Foundation
import UIKit

final class GlobalAlert {
    
    func commonAlert(title: String, content: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        
        // Change font and color of title
        
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17,weight: UIFont.Weight.bold), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
        
        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular), NSAttributedString.Key.foregroundColor :UIColor.black]), forKey: "attributedMessage")
        
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { (action:UIAlertAction!) in
            
        }))
        
        subview.backgroundColor = UIColor.white
        vc.present(alert, animated: true)
    }
}
