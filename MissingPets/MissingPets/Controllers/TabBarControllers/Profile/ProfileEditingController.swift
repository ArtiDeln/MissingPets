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
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        txtFld.clearButtonMode = .whileEditing
        txtFld.placeholder = "Имя"
        return txtFld
    }()
    
    private(set) lazy var emailField: UITextField = {
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        txtFld.clearButtonMode = .whileEditing
        txtFld.placeholder = "Email"
        txtFld.autocapitalizationType = .none
        return txtFld
    }()
    
    private(set) lazy var oldPasswordField: UITextField = {
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        txtFld.clearButtonMode = .whileEditing
        txtFld.placeholder = "Действительный пароль"
        txtFld.isSecureTextEntry = true
        return txtFld
    }()
    
    private(set) lazy var newPasswordField: UITextField = {
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        txtFld.clearButtonMode = .whileEditing
        txtFld.placeholder = "Новый пароль"
        txtFld.isSecureTextEntry = true
        return txtFld
    }()
    
    private(set) lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Сохранить", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        return btn
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
            alert(alertTitle: "Заполните все поля!", alertMessage: nil, alertActionTitle: "OK")
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
        
        self.updateUserEmailAndPassword()
        
        let alert = UIAlertController(title: "Изменения сохранены успешно", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func updateUserEmailAndPassword() {
        
        Auth.auth().currentUser?.updateEmail(to: emailField.text!) { error in
            if let error = error {
                print(error)
                self.alert(alertTitle: "Ошибка", alertMessage: "Перезайдите в аккаунт и повторите попытку", alertActionTitle: "OK")
            }
        }
        
        Auth.auth().currentUser?.updatePassword(to: oldPasswordField.text!) { error in
            if let error = error {
                print(error)
                self.alert(alertTitle: "Ошибка", alertMessage: "Перезайдите в аккаунт и повторите попытку", alertActionTitle: "OK")
            }
        }
    }
    
    private func alert(alertTitle: String?, alertMessage: String?, alertActionTitle: String?) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: alertActionTitle, style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
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
