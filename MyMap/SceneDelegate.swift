//
//  SceneDelegate.swift
//  MyMap
//
//  Created by Руслан Магомедов on 21.09.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let tabBar = MainTabBarController()
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }

}
