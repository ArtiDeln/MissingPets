//
//  AuthController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 23.05.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AuthVC: UIViewController, UITextFieldDelegate {
    
    //MARK: - GUI
    
    let startLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход"
        label.font = .boldSystemFont(ofSize: 45)
        return label
    }()
    
    let emailField: UITextField = {
        let email = UITextField()
        email.borderStyle = .roundedRect
        email.placeholder = "Email"
        email.autocapitalizationType = .none
        return email
    }()
    
    let passwordField: UITextField = {
        let password = UITextField()
        password.borderStyle = .roundedRect
        password.placeholder = "Пароль"
        password.isSecureTextEntry = true
        return password
    }()
    
    let logInBtn: UIButton = {
        let logIn = UIButton()
        logIn.setTitle("Войти", for: .normal)
        logIn.backgroundColor = .systemBlue
        logIn.layer.cornerRadius = 10
        return logIn
    }()
    
    let signInBtn: UIButton = {
        let signIn = UIButton()
        signIn.setTitle("Зарегистрироваться", for: .normal)
        signIn.backgroundColor = .systemRed
        signIn.layer.cornerRadius = 10
        return signIn
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет аккаунта?"
        return label
    }()
    
    
    
    //MARK: - Initialisation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.startLabel)
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.passwordField)
        self.view.addSubview(self.logInBtn)
        self.view.addSubview(self.signInBtn)
        self.view.addSubview(self.questionLabel)
        
        self.logInBtn.addTarget(self, action: #selector(didTapLogInBtn), for: .touchUpInside)
        
        //        self.emailField.delegate = self
        //        self.passwordField.delegate = self
        
        self.constraints()
        
        self.setupHideKeyboardOnTap()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    //MARK: - objc func
    
    @objc private func didTapLogInBtn() {
        print("Test")
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            print("Missing field")
            let alert = UIAlertController(title: "Заполните все поля", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            print("вы вошли")
            
            strongSelf.emailField.isHidden = true
            //            strongSelf.present(test, animated: true)
            //            strongSelf.passwordField.isHidden = true
            //            strongSelf.logInBtn.isHidden = true
            //            strongSelf.signInBtn.isHidden = true
        })
    }
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        self.view.endEditing(true)
    //        return false
    //    }
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Учетная запись отсутствует", message: "Хотите создать аккаунт?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Создать", style: .default, handler: {_ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else {
                    print("Account created failed")
                    return
                }
                print(result?.user.uid ?? "error")
                let ref = Database.database().reference().child("users")
                
                ref.child(result?.user.uid ?? "Error").updateChildValues(["email" : email])
                print("вы вошли")
                
                strongSelf.emailField.isHidden = true
                
            })
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: {_ in
            
        }))
        
        present(alert, animated: true)
    }
    
    //MARK: - Constraints
    
    private func constraints() {
        self.startLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalToSuperview().inset(150)
        }
        self.emailField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(startLabel.snp.bottom).inset(-15)
        }
        self.passwordField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(emailField.snp.bottom).inset(-15)
        }
        self.logInBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(passwordField.snp.bottom).inset(-15)
        }
        self.questionLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(logInBtn.snp.bottom).inset(-15)
        }
        self.signInBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(90)
            $0.top.equalTo(questionLabel.snp.bottom).inset(-15)
        }
    }
}

extension UIViewController {
    
    //MARK: - Hide keyboard
    
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
