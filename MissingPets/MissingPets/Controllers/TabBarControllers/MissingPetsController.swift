//
//  MainController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 18.05.22.
//

import UIKit

class MissingPetsVC: UIViewController {
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Пропавшие животные"
    }
    
}
