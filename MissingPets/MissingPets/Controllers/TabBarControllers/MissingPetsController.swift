//
//  MainController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 18.05.22.
//

import UIKit
import Firebase

class MissingPetsVC: UIViewController {
    
    let testBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Test", for: .normal)
        btn.backgroundColor = .systemRed
        return btn
    }()
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.testBtn.addTarget(self, action: #selector(testing), for: .touchUpInside)
        
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Пропавшие питомцы"
        
        view.addSubview(testBtn)
        testBtn.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(200)
        }
    }
    //TODO: - Custom TableViewCell and TableView
    @objc func testing() {
        let ref = Database.database().reference()
        ref.child("Test iOS Missing Animals").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                for index in 0..<dictionary.count {
                    let currentKey = dictionary.keys.sorted()[index] // ID
                    let currentGame = dictionary[currentKey]
                    print(currentGame as Any)
//                    let adress = currentGame?["status"] as! String // Address
//                    let name = currentGame?["name"] as! String
//                    print("Name: \(name), status: \(adress), dictionary count = \(dictionary.count)")
                }
            }
        })
    }
}
