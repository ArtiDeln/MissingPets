//
//  MainController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 18.05.22.
//

import UIKit

class MissingPetsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Пропавшие животные"
//        title = "aaa"
        
//        let segmentControl: UISegmentedControl = {
//            let control = UISegmentedControl(items: ["Пропавшие", "Найденные"])
//            control.selectedSegmentIndex = 0
//            control.addTarget(self, action: #selector(test(_:)), for: .valueChanged)
//            return control
//        }()
//        self.navigationItem.titleView = segmentControl
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
//
//        self.test(segmentControl)
    }
    
//    @objc func test(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0: present(ProfileController(), animated: true)
//
//        default:
//            view.backgroundColor = .systemBackground
//        }
//    }
}
