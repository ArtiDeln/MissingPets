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
    
    private(set) lazy var loginLabel: UILabel = {
        let login = UILabel()
        login.text = "Вход"
        login.font = .boldSystemFont(ofSize: 45)
        return login
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
    
    private(set) lazy var logInBtn: UIButton = {
        let logIn = UIButton()
        logIn.setTitle("Войти", for: .normal)
        logIn.backgroundColor = .systemBlue
        logIn.layer.cornerRadius = 10
        return logIn
    }()
    
    private(set) lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет аккаунта?"
        return label
    }()
    
    private(set) lazy var signInBtn: UIButton = {
        let signIn = UIButton()
        signIn.setTitle("Зарегистрироваться", for: .normal)
        signIn.backgroundColor = .systemRed
        signIn.layer.cornerRadius = 10
        return signIn
    }()
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.logInBtn.addTarget(self, action: #selector(didTapLogInBtn), for: .touchUpInside)
        self.signInBtn.addTarget(self, action: #selector(didTapSignInBtn), for: .touchUpInside)
        
        self.initView()
        self.constraints()
        self.setupHideKeyboardOnTap()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    //MARK: - Initialization
    
    private func initView() {
        self.view.addSubview(self.loginLabel)
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.passwordField)
        self.view.addSubview(self.logInBtn)
        self.view.addSubview(self.questionLabel)
        self.view.addSubview(self.signInBtn)
    }
    
    //MARK: - @objc functions

    @objc private func didTapLogInBtn() {
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
            let user = result?.user
            print("Logged in user: \(String(describing: user))")
        })
    }
        
    @objc private func didTapSignInBtn() {
        let rootVC = RegistrationVC()
        let navController = UINavigationController(rootViewController: rootVC)

        rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад",
                                                                  style: .plain,
                                                                  target: self,
                                                                  action: #selector(dismissTapped))
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    @objc private func dismissTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Functions
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Учетная запись отсутствует", message: "Хотите создать аккаунт?", preferredStyle: .alert)
        let createBtn = UIAlertAction(title: "Создать", style: .default) { (alert) in
            self.didTapSignInBtn()
        }
        let cancelBtn = UIAlertAction(title: "Отмена", style: .default, handler: .none)
        
        alert.addAction(createBtn)
        alert.addAction(cancelBtn)
        
        present(alert, animated: true)
    }
    
    //MARK: - Constraints
    
    private func constraints() {
        self.loginLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalToSuperview().inset(150)
        }
        self.emailField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(loginLabel.snp.bottom).inset(-15)
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
