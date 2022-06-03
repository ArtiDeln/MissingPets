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
    
    //    var ref: DatabaseReference!
    
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
        
        
        //        ref = Database.database().reference()
    }
    
    private func initView() {
        self.view.addSubview(emailLabel)
        self.view.addSubview(myAnnounsBtn)
        self.view.addSubview(profileEditBtn)
        self.view.addSubview(logOutBtn)
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
    
    private func setName() {
        
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
                    let userName = data["name"] as? String ?? "UnidentifiedUser"
                    self.emailLabel.text = userName
                    print("User name = \(userName)")
                }
        }
        
        //        if let user = user { //добавить в viewDidAppear
        //            ref.child("Users/\(user.uid)").observeSingleEvent(of: .value, with: { snapshot in
        //                let value = snapshot.value as? NSDictionary
        //                let username = value?["name"] as? String ?? "UnidentifiedUser"
        //                self.emailLabel.text = "\(username)"
        //            }) { error in
        //                print(error.localizedDescription)
        //            }
        //        }
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
