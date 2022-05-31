////
////  ProfileController.swift
////  MissingPets
////
////  Created by Artyom Butorin on 18.05.22.
////

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    //MARK: - GUI
    
    private(set) lazy var emailLabel: UILabel = {
        let email = UILabel()
        return email
    }()
    
    private(set) lazy var myAnnounsBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Мои объявления", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
//        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(myAnnounsTapped), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var profileEditBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Редактировать профиль", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
//        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(profileEditTapped), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var logOutBtn: UIButton = {
        let logOut = UIButton()
        logOut.setTitle("Выйти", for: .normal)
        logOut.backgroundColor = .systemGray
        logOut.layer.cornerRadius = 10
//        logOut.titleLabel?.font = .systemFont(ofSize: 12)
        logOut.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        return logOut
    }()
    
    //MARK: - Constants
    
    let user = Auth.auth().currentUser
    
    //MARK: - Initialisation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
//        self.navigationController?.view.backgroundColor = .darkGray
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Профиль"
        
        self.view.addSubview(emailLabel)
        self.view.addSubview(myAnnounsBtn)
        self.view.addSubview(profileEditBtn)
        self.view.addSubview(logOutBtn)
        
        self.setData()
        self.constraints()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(logOutTapped))
    }
    
    //MARK: - @objc functions
    
    @objc private func myAnnounsTapped() {
        let vc = MyAnnounsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func profileEditTapped() {
        let vc = ProfileEditingVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func logOutTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print("Error")
        }
    }
    
    //MARK: - Set data
    
    private func setData() {
        if let user = user {
            emailLabel.text = "Email: \((user.email ?? "Error") as String)"
            var multiFactorString = "MultiFactor: "
            for info in user.multiFactor.enrolledFactors {
              multiFactorString += info.displayName ?? "[DispayName]"
              multiFactorString += " "
                print(multiFactorString)
            }
        }
    }
    
    //MARK: - Constraints
    
    private func constraints() {
        emailLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.bottom.equalTo(self.myAnnounsBtn.snp.top).inset(-20)
        }
        myAnnounsBtn.snp.makeConstraints {
            $0.left.right.equalTo(self.view).inset(60)
            $0.centerY.equalTo(self.view)
        }
        profileEditBtn.snp.makeConstraints {
            $0.left.right.equalTo(self.view).inset(60)
            $0.top.equalTo(self.myAnnounsBtn.snp.bottom).inset(-20)
        }
        logOutBtn.snp.makeConstraints {
            $0.right.left.equalTo(self.view).inset(60)
            $0.bottom.equalTo(self.view).inset(100)
        }
    }
    
}
