//
//  TabBarViewController.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
        setUpTabBarItem()
    }
    
    func setUpTabBar() {
        tabBar.barTintColor = .systemBackground
        tabBar.tintColor = .link
    }
    
    func setUpTabBarItem() {
        // 인스턴스화
        let vc1 = TodayViewController()
        let vc2 = ViewController()
        let vc3 = ViewController()
        let vc4 = ViewController()
        let vc5 = SearchViewController()
        
        // 각 tab bar의 item 설정
        let fontAttributes = [NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.regular)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes as [NSAttributedString.Key : Any], for: .normal)
        
        let tabBarItem1 = UITabBarItem(title: "투데이",
                                       image: UIImage(systemName: "doc.text.image"),
                                       selectedImage: UIImage(systemName: "doc.text.image"))
        vc1.tabBarItem = tabBarItem1
        let tabBarItem2 = UITabBarItem(title: "게임",
                                       image: UIImage(systemName: "circle.grid.cross.up.filled"),
                                       selectedImage: UIImage(systemName: "circle.grid.cross.up.filled"))
        vc2.tabBarItem = tabBarItem2
        let tabBarItem3 = UITabBarItem(title: "앱",
                                       image: UIImage(systemName: "rectangle.grid.2x2"),
                                       selectedImage: UIImage(systemName: "rectangle.grid.2x2"))
        vc3.tabBarItem = tabBarItem3
        let tabBarItem4 = UITabBarItem(title: "Arcade",
                                       image: UIImage(systemName: "gamecontroller"),
                                       selectedImage: UIImage(systemName: "gamecontroller"))
        vc4.tabBarItem = tabBarItem4
        let tabBarItem5 = UITabBarItem(title: "검색",
                                       image: UIImage(systemName: "magnifyingglass"),
                                       selectedImage: UIImage(systemName: "magnifyingglass"))
        vc5.tabBarItem = tabBarItem5
        
        // navigationController의 root view 설정
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        let nav5 = UINavigationController(rootViewController: vc5)
        
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: false)
    }
}
