//
//  ProfileEditingVC.swift
//  MissingPets
//
//  Created by Artyom Butorin on 31.05.22.
//

import UIKit

class ProfileEditingVC: UIViewController {
    
    //MARK: - GUI
    
    private(set) lazy var profileEditLabel: UILabel = {
        let label = UILabel()
        label.text = "Редактирование профиля"
        label.font = .boldSystemFont(ofSize: 25)
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
    
    private(set) lazy var saveBtn: UIButton = {
        let save = UIButton()
        save.setTitle("Зарегистрироваться", for: .normal)
        save.backgroundColor = .systemBlue
        save.layer.cornerRadius = 10
        return save
    }()
    
    //MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Изменение профиля"
        
        self.initView()
        self.constraints()
        self.setupHideKeyboardOnTap()
    }
    
    private func initView(){
        self.view.addSubview(self.profileEditLabel)
        self.view.addSubview(self.nameField)
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.passwordField)
        self.view.addSubview(self.saveBtn)
    }
    
    //MARK: - Constraints
    
    private func constraints() {
        self.profileEditLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalToSuperview().inset(150)
        }
        self.nameField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(profileEditLabel.snp.bottom).inset(-15)
        }
        self.emailField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(nameField.snp.bottom).inset(-15)
        }
        self.passwordField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(emailField.snp.bottom).inset(-15)
        }
        self.saveBtn.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(passwordField.snp.bottom).inset(-15)
        }
    }

}
