//
//  ProfileEditingVC.swift
//  MissingPets
//
//  Created by Artyom Butorin on 31.05.22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileEditingVC: UIViewController {
    
    let user = Auth.auth().currentUser
    
    //MARK: - GUI
    
    private(set) lazy var nameField: UITextField = {
        let name = UITextField()
        name.borderStyle = .roundedRect
        name.placeholder = "Имя"
        name.autocapitalizationType = .none
        return name
    }()
    
    private(set) lazy var emailField: UITextField = {
        let email = UITextField()
        email.borderStyle = .roundedRect
        email.placeholder = "Email"
        email.autocapitalizationType = .none
        return email
    }()
    
    private(set) lazy var oldPasswordField: UITextField = {
        let password = UITextField()
        password.borderStyle = .roundedRect
        password.placeholder = "Действительный пароль"
        password.isSecureTextEntry = true
        return password
    }()
    
    private(set) lazy var newPasswordField: UITextField = {
        let password = UITextField()
        password.borderStyle = .roundedRect
        password.placeholder = "Новый пароль"
        password.isSecureTextEntry = true
        return password
    }()
    
    private(set) lazy var saveBtn: UIButton = {
        let save = UIButton()
        save.setTitle("Сохранить", for: .normal)
        save.backgroundColor = .systemBlue
        save.layer.cornerRadius = 10
        return save
    }()
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Изменение профиля"
        
        self.saveBtn.addTarget(self, action: #selector(self.saveBtnTapped), for: .touchUpInside)
        
        self.initView()
        self.constraints()
        self.setCurrentDataToTextFields()
        self.setupHideKeyboardOnTap()
    }
    
    //MARK: - Initialization
    
    private func initView(){
        self.view.addSubview(self.nameField)
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.oldPasswordField)
        self.view.addSubview(self.newPasswordField)
        self.view.addSubview(self.saveBtn)
    }
    
    func setCurrentDataToTextFields() {
        if let user = user {
            Firestore.firestore().collection("TestUsers").document(user.uid)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                    }
                    self.nameField.text = data["name"] as? String ?? "UnidentifiedUser"
                    self.emailField.text = data["email"] as? String ?? "UnidentifiedEmail"
                }
        }
    }
    
    @objc func saveBtnTapped() {
        
        guard let name = nameField.text, !name.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let password = oldPasswordField.text, !password.isEmpty else {
            print("Missing field")
            let alert = UIAlertController(title: "Заполните все поля", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        
        if let user = user {
            Firestore.firestore().collection("Users").document(user.uid)
                .updateData([
                    "name": nameField.text ?? "",
                    "email": emailField.text ?? ""
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
        }
        
        self.updateUserEmailWithPassword()
        
        let alert = UIAlertController(title: "Изменено успешно", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func updateUserEmailWithPassword() {
        
        Auth.auth().currentUser?.updateEmail(to: emailField.text!) { error in
            if let error = error {
                print(error)
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
        
        Auth.auth().currentUser?.updatePassword(to: oldPasswordField.text!) { error in
            if let error = error {
                print(error)
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    //MARK: - Constraints
    
    private func constraints() {
        self.nameField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.bottom.equalTo(self.emailField.snp.top).inset(-15)
        }
        self.emailField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.bottom.equalTo(self.oldPasswordField.snp.top).inset(-15)
        }
        self.oldPasswordField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.centerY.equalTo(self.view)
        }
        self.newPasswordField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(self.oldPasswordField.snp.bottom).inset(-15)
        }
        self.saveBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(self.newPasswordField.snp.bottom).inset(-15)
        }
    }
    
}
