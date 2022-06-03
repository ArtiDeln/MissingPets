//
//  RegistrationController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 30.05.22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseFirestore

class RegistrationVC: UIViewController {
    
    //MARK: - GUI
        
    private(set) lazy var registrationLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.font = .boldSystemFont(ofSize: 45)
        return label
    }()
    
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
    
    private(set) lazy var passwordField: UITextField = {
        let password = UITextField()
        password.borderStyle = .roundedRect
        password.placeholder = "Пароль"
        password.isSecureTextEntry = true
        return password
    }()
    
    private(set) lazy var signInBtn: UIButton = {
        let signIn = UIButton()
        signIn.setTitle("Зарегистрироваться", for: .normal)
        signIn.backgroundColor = .systemBlue
        signIn.layer.cornerRadius = 10
        return signIn
    }()
    
    //MARK: - Variable
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.registrationLabel)
        self.view.addSubview(self.nameField)
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.passwordField)
        self.view.addSubview(self.signInBtn)
        
        db = Firestore.firestore()
        
        self.signInBtn.addTarget(self, action: #selector(didTapSignInBtn), for: .touchUpInside)
        
        self.constraints()
        self.setupHideKeyboardOnTap()
    }
    
    @objc func didTapSignInBtn() {
        guard let name = nameField.text, !name.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            print("Missing field")
            let alert = UIAlertController(title: "Заполните все поля", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
            
            guard let _ = self else { return } //let strongSelf = self
            guard error == nil else {
                print("Account created failed")
                return
            }
            
            self?.db.collection("TestUsers").document(result?.user.uid ?? "Error").setData(["name": name,
                                                                                            "email": email]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            //            print(result?.user.uid ?? "error")
            //            let ref = Database.database().reference().child("Users")
            //            ref.child(result?.user.uid ?? "Error").updateChildValues(["name" : name])
            //            ref.child(result?.user.uid ?? "Error").updateChildValues(["email" : email])
            //            ref.child(result?.user.uid ?? "Error").updateChildValues(["uid" : result!.user.uid])
        })
        print("Successfully logged in")
        
        //TODO: - ALERT
        //        sleep(1)
        //        self.successfulAlert()
    }
    
    func successfulAlert() {
        print("АЛЕРТ СРАБОТАЛ")
        let alertController = UIAlertController(title: "Сохранено",
                                                message: "Успешно",
                                                preferredStyle: .actionSheet)
        self.presentedViewController?.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Constraints
    
    private func constraints() {
        self.registrationLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalToSuperview().inset(150)
        }
        self.nameField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(registrationLabel.snp.bottom).inset(-15)
        }
        self.emailField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(nameField.snp.bottom).inset(-15)
        }
        self.passwordField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(emailField.snp.bottom).inset(-15)
        }
        self.signInBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(passwordField.snp.bottom).inset(-15)
        }
    }
}
