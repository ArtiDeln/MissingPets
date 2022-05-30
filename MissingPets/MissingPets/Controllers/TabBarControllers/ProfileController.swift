////
////  ProfileController.swift
////  MissingPets
////
////  Created by Artyom Butorin on 18.05.22.
////

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    let user = Auth.auth().currentUser
    
    //MARK: GUI
    
    let emailLabel: UILabel = {
        let email = UILabel()
        return email
    }()
    
    let logOutBtn: UIButton = {
        let logOut = UIButton()
        logOut.setTitle("Log Out", for: .normal)
        logOut.backgroundColor = .systemGray
        logOut.layer.cornerRadius = 10
        logOut.titleLabel?.font = .systemFont(ofSize: 12)
        logOut.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        return logOut
    }()
    
    //MARK: - Initialisation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.navigationController?.view.backgroundColor = .darkGray
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Profile"
        
        self.view.addSubview(emailLabel)
        self.view.addSubview(logOutBtn)
        
        self.setData()
        self.constraints()

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
//            $0.top.equalToSuperview().inset(150)
            $0.centerY.equalTo(self.view)
        }
        logOutBtn.snp.makeConstraints {
            $0.right.left.equalTo(self.view).inset(120)
            $0.bottom.equalTo(self.view).inset(100)
        }
    }
    
}
