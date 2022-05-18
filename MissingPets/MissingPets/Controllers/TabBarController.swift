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
        tabBar.barTintColor = .yellow
        
        let mainVC = MainVC()
        let addPetVC = AddPetVC()
        let mapVC = MapVC()
        let testVC = TestController()
        let profileVC = ProfileController()
        
        mainVC.tabBarItem.image = UIImage(systemName: "square.stack")
        addPetVC.tabBarItem.image = UIImage(systemName: "plus.circle")
        mapVC.tabBarItem.image = UIImage(systemName: "map")
        testVC.tabBarItem.image = UIImage(systemName: "person.2.crop.square.stack")
        profileVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        self.setViewControllers([mainVC, testVC, addPetVC, profileVC, mapVC], animated: false)
    }
}

import UIKit

class TestController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
