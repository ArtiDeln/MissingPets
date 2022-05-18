//
//  ProfileController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 18.05.22.
//

import UIKit

class ProfileController: UIViewController {
    
    let username = UITextField()
    let password = UITextField()
    let logIn = UIButton()
    let signIn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.username)
        self.view.addSubview(self.password)
        self.view.addSubview(self.logIn)
        self.view.addSubview(self.signIn)
        
        self.view.backgroundColor = .systemBackground
        
        self.username.borderStyle = .roundedRect
        self.username.placeholder = "Логин"
        
        self.password.borderStyle = .roundedRect
        self.password.placeholder = "Пароль"
        
        self.logIn.setTitle("Войти", for: .normal)
        self.logIn.backgroundColor = .systemBlue
        self.logIn.layer.cornerRadius = 10
        
        self.signIn.setTitle("Зарегистрироваться", for: .normal)
        self.signIn.backgroundColor = .systemBlue
        self.signIn.layer.cornerRadius = 10
        
        self.constraints()
        
    }
    
    private func constraints() {
        self.username.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalToSuperview().inset(50)
        }
        self.password.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(username.snp.bottom).inset(-15)
        }
        self.logIn.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(password.snp.bottom).inset(-15)
        }
        self.signIn.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(logIn.snp.bottom).inset(-15)
        }
    }
}
