//
//  MainTabBarController.swift
//  MyMap
//
//  Created by Руслан Магомедов on 21.09.2022.
//

import UIKit


final class MainTabBarController: UITabBarController {

    private lazy var mapKitNC: UINavigationController = {
        let presenter = MapPresenter()
        let view = MapViewController(presenter: presenter)
        presenter.view = view
        let navigation = UINavigationController(rootViewController: view)
        navigation.tabBarItem = UITabBarItem(title: "title_map".localized,
                                             image: UIImage(systemName: "map"),
                                             selectedImage: UIImage(systemName: "map.fil"))
        navigation.navigationBar.topItem?.title = "title_map".localized
        return navigation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(named: "barTintColor")
        viewControllers = [mapKitNC]
    }


}
