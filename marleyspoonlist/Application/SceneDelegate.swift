//
//  SceneDelegate.swift
//  marleyspoonlist
//
//  Created by Jose Frometa on 1/7/20.
//  Copyright © 2020 Jose Frometa. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let wScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: wScene.coordinateSpace.bounds)
        window?.windowScene = wScene
        
        let navigator = DefaultRecipiesNavigator(navigationController: self.navigationController)
        
        let model = RecipiesListViewModel(navigator: navigator, provider: ContentfulManager.shared)
        
        let vc = RecepiesListViewController(with: model)
        
        self.navigationController = UINavigationController(rootViewController: vc)
        navigator.navigationController = self.navigationController
            
        // ignores the user theme settings and enforces .lightMode
        if #available(iOS 13.0, *) {
          window?.overrideUserInterfaceStyle = .light
        }
        
        window?.rootViewController = self.navigationController
        window?.makeKeyAndVisible()
    }
}

