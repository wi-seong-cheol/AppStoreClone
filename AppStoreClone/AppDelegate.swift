//
//  AppDelegate.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        utilRegisterDependencies()
        serviceRegisterDependencies()
        
//        let style = NSMutableParagraphStyle()
//        style.firstLineHeadIndent = 4
//        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.paragraphStyle : style]
        
        return true
    }
    
    private func utilRegisterDependencies() {
        DIContainer.shared.register(GlobalAlert())
        DIContainer.shared.register(ImageCache())
        DIContainer.shared.register(ReadPList())
        DIContainer.shared.register(ReadJson())
        let globalAlert: GlobalAlert = DIContainer.shared.resolve()
        let imageCache: ImageCache = DIContainer.shared.resolve()
        let readPList: ReadPList = DIContainer.shared.resolve()
        let readJson: ReadJson = DIContainer.shared.resolve()
        DIContainer.shared.register(globalAlert)
        DIContainer.shared.register(imageCache)
        DIContainer.shared.register(readPList)
        DIContainer.shared.register(readJson)
    }
    
    private func serviceRegisterDependencies() {
        DIContainer.shared.register(HeaderCommon())
        DIContainer.shared.register(APIRequestService())
        DIContainer.shared.register(URLService())
        DIContainer.shared.register(ImageLoader())
        DIContainer.shared.register(ItunesService())
        let headerCommon: HeaderCommon = DIContainer.shared.resolve()
        let apiRequestService: APIRequestService = DIContainer.shared.resolve()
        let urlService: URLService = DIContainer.shared.resolve()
        let imageLoader: ImageLoader = DIContainer.shared.resolve()
        let itunesService: ItunesService = DIContainer.shared.resolve()
        DIContainer.shared.register(headerCommon)
        DIContainer.shared.register(apiRequestService)
        DIContainer.shared.register(urlService)
        DIContainer.shared.register(imageLoader)
        DIContainer.shared.register(itunesService)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
