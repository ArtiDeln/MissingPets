//
//  TabBarController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 18.05.22.
//

import UIKit
import SnapKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .systemBackground
//        tabBar.barTintColor = .systemOrange
        self.setupTabBar()
        
    }
    
    func setupTabBar() {
        let mainVC = createNavController(vc: MissingPetsVC(), itemName: "Пропали", iconName: "square.stack")
        let addPetVC = createNavController(vc: AddPetVC(), itemName: "", iconName: "plus.circle")
        let mapVC = createNavController(vc: MapVC(), itemName: "Карта", iconName: "map")
        let testVC = createNavController(vc: FoundPetsVC(), itemName: "Найдены", iconName: "person.2.crop.square.stack")
        let profileVC = createNavController(vc: ProfileVC(), itemName: "Профиль", iconName: "person.crop.circle")
        self.setViewControllers([mainVC, testVC, addPetVC, profileVC, mapVC], animated: true)
    }
    
    func createNavController(vc: UIViewController, itemName: String, iconName: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: iconName), tag: 0)
//        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        return navController
    }
}
