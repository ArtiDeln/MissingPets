////
////  ProfileController.swift
////  MissingPets
////
////  Created by Artyom Butorin on 18.05.22.
////

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {

    let startLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход"
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground

        self.navigationController?.view.backgroundColor = .darkGray
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Profile"

        self.view.addSubview(self.startLabel)
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.passwordField)
        self.view.addSubview(self.logInBtn)
        self.view.addSubview(self.signInBtn)
        self.view.addSubview(self.questionLabel)
        
        self.logInBtn.addTarget(self, action: #selector(didTapLogInBtn), for: .touchUpInside)

        self.constraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//    }
    
    @objc private func didTapLogInBtn() {
        print("Test")
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            print("Missing field")
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
//            strongSelf.passwordField.isHidden = true
//            strongSelf.logInBtn.isHidden = true
//            strongSelf.signInBtn.isHidden = true
        })
    }
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Создать аккаунт?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue?", style: .default, handler: {_ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else {
                    print("Account created failed")
                    return
                }
                print("вы вошли")
                strongSelf.emailField.isHidden = true
    //            strongSelf.passwordField.isHidden = true
    //            strongSelf.logInBtn.isHidden = true
    //            strongSelf.signInBtn.isHidden = true
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel?", style: .cancel, handler: {_ in
            
        }))
        
        present(alert, animated: true)
    }

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
