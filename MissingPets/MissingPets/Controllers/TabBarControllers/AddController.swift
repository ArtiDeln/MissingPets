//
//  ViewController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 18.05.22.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddPetVC: UIViewController {
    
    private(set) var picker: UIPickerView = {
        let languagePicker = UIPickerView()
        languagePicker.translatesAutoresizingMaskIntoConstraints = false
        return languagePicker
    }()
    
    private(set) var field: UITextField = {
        let field = UITextField()
        field.placeholder = "Test"
        return field
    }()
    
    let test = ["test1","test2"]
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
    }
}
