//
//  TabBarController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 18.05.22.
//

import UIKit
import SnapKit

class TabBarController: UITabBarController {
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .systemBackground
        
        self.setupTabBar()
    }
    
    //MARK: - Functions
    
    private func setupTabBar() {
        let mainVC = createNavController(vc: MissingPetsVC(),
                                         itemName: "Пропали",
                                         iconName: "pawprint")
        let testVC = createNavController(vc: FoundPetsVC(),
                                         itemName: "Найдены",
                                         iconName: "pawprint.fill")
        let addPetVC = createNavController(vc: AddPetVC(),
                                           itemName: "",
                                           iconName: "plus.circle")
        let profileVC = createNavController(vc: ProfileVC(),
                                            itemName: "Профиль",
                                            iconName: "person.crop.square.fill")
        let mapVC = createNavController(vc: MapVC(),
                                        itemName: "Карта",
                                        iconName: "map.fill")
        self.setViewControllers([mainVC, testVC, addPetVC, profileVC, mapVC], animated: true)
    }
    
    private func createNavController(vc: UIViewController, itemName: String, iconName: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: iconName), tag: 0)
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        return navController
    }
}
