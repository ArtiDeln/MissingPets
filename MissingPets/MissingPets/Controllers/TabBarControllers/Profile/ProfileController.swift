////
////  ProfileController.swift
////  MissingPets
////
////  Created by Artyom Butorin on 18.05.22.
////

import UIKit
import Firebase
import FirebaseFirestore

class ProfileVC: UIViewController {
    
    //MARK: - Constants
    
    let user = Auth.auth().currentUser
    
    //MARK: - Variables
    
    //MARK: - GUI
    
    private(set) lazy var nameLbl: UILabel = {
        let email = UILabel()
        return email
    }()
    
    private(set) lazy var myAnnounsBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Мои объявления", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(myAnnounsTapped), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var profileEditBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Редактировать профиль", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(profileEditTapped), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var logOutBtn: UIButton = {
        let logOut = UIButton()
        logOut.setTitle("Выйти", for: .normal)
        logOut.backgroundColor = .systemGray
        logOut.layer.cornerRadius = 10
        logOut.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        return logOut
    }()
    
    //MARK: - Initialisation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Профиль"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(logOutTapped))
        
        self.initView()
        self.constraints()
        self.setName()
    }
    
    private func initView() {
        self.view.addSubview(self.nameLbl)
        self.view.addSubview(self.myAnnounsBtn)
        self.view.addSubview(self.profileEditBtn)
        self.view.addSubview(self.logOutBtn)
    }
    
    //MARK: - @objc functions
    
    @objc private func myAnnounsTapped() {
        let vc = MyAnnounceVC()
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
    
    private func setName() {
        
        if let user = user {
            Firestore.firestore().collection("Users").document(user.uid)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                    }
                    let userName = data["name"] as? String ?? "UnidentifiedUser"
                    self.nameLbl.text = userName
                    print("User name = \(userName)")
                }
        }
    }
    
    //MARK: - Constraints
    
    private func constraints() {
        self.nameLbl.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.bottom.equalTo(self.myAnnounsBtn.snp.top).inset(-20)
        }
        self.myAnnounsBtn.snp.makeConstraints {
            $0.left.right.equalTo(self.view).inset(60)
            $0.centerY.equalTo(self.view)
        }
        self.profileEditBtn.snp.makeConstraints {
            $0.left.right.equalTo(self.view).inset(60)
            $0.top.equalTo(self.myAnnounsBtn.snp.bottom).inset(-20)
        }
        self.logOutBtn.snp.makeConstraints {
            $0.right.left.equalTo(self.view).inset(60)
            $0.bottom.equalTo(self.view).inset(100)
        }
    }
    
}
