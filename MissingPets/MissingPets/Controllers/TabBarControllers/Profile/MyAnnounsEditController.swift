//
//  MyAnnounsEditController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 8.06.22.
//

import UIKit
import FirebaseFirestore

class MyAnnouncEditVC: UIViewController, UIScrollViewDelegate {
    
    public lazy var number = String()
    
    public lazy var myPetID = String()
    
    //MARK: -GUI
    
    private(set) lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private(set) lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private(set) var petPhotoImg: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.gray
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private(set) lazy var petNameTxtFld: UITextField = {
        let name = UITextField()
        name.borderStyle = .roundedRect
        name.placeholder = "Кличка"
        name.textAlignment = .center
        name.autocapitalizationType = .none
        return name
    }()
    
    private(set) lazy var petTypeTxtFld: UITextField = {
        let type = UITextField()
        type.borderStyle = .roundedRect
        type.placeholder = "Тип"
        type.textAlignment = .center
        type.autocapitalizationType = .none
        return type
    }()
    
    private(set) lazy var petBreedTxtFld: UITextField = {
        let breed = UITextField()
        breed.borderStyle = .roundedRect
        breed.placeholder = "Порода"
        breed.textAlignment = .center
        breed.autocapitalizationType = .none
        return breed
    }()
    
    private(set) lazy var petGenderTxtFld: UITextField = {
        let gender = UITextField()
        gender.borderStyle = .roundedRect
        gender.placeholder = "Пол"
        gender.textAlignment = .center
        gender.autocapitalizationType = .none
        return gender
    }()
    
    private(set) lazy var petMissingAdressTxtFld: UITextField = {
        let missingAddress = UITextField()
        missingAddress.borderStyle = .roundedRect
        missingAddress.placeholder = "Адрес"
        missingAddress.textAlignment = .center
        missingAddress.autocapitalizationType = .none
        return missingAddress
    }()
    
    private(set) lazy var petAdditionalInfoTxtFld: UITextField = {
        let additionalInfo = UITextField()
        additionalInfo.borderStyle = .roundedRect
        additionalInfo.placeholder = "Доп. информация"
        additionalInfo.textAlignment = .center
        additionalInfo.autocapitalizationType = .none
        return additionalInfo
    }()
    
    private(set) lazy var phoneTxtFld: UITextField = {
        let phone = UITextField()
        phone.borderStyle = .roundedRect
        phone.placeholder = "Номер телефона"
        phone.textAlignment = .center
        phone.autocapitalizationType = .none
        return phone
    }()
    
    private(set) var editBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Изменить", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    private(set) var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Удалить запись", for: .normal)
        btn.backgroundColor = .systemRed
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.editBtn.addTarget(self, action: #selector(editBtnTapped), for: .touchUpInside)
        self.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        
        self.showPetName()
        self.initView()
        self.constraints()
    }
    
    private func initView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(self.petPhotoImg)
        self.contentView.addSubview(self.petNameTxtFld)
        self.contentView.addSubview(self.petTypeTxtFld)
        self.contentView.addSubview(self.petBreedTxtFld)
        self.contentView.addSubview(self.petGenderTxtFld)
        self.contentView.addSubview(self.petMissingAdressTxtFld)
        self.contentView.addSubview(self.petAdditionalInfoTxtFld)
        self.contentView.addSubview(self.phoneTxtFld)
        self.contentView.addSubview(self.editBtn)
        self.contentView.addSubview(self.deleteBtn)
    }
    
    private func constraints() {
        self.scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view)
        }
        self.contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView)
            $0.width.equalTo(self.view)
        }
        self.petPhotoImg.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(contentView)
            $0.size.equalTo(250)
        }
        self.petNameTxtFld.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.width.equalTo(self.contentView).inset(50)
            $0.top.equalTo(petPhotoImg.snp.bottom).inset(-10)
        }
        self.petTypeTxtFld.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.width.equalTo(self.contentView).inset(50)
            $0.top.equalTo(petNameTxtFld.snp.bottom).inset(-10)
        }
        self.petBreedTxtFld.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.width.equalTo(self.contentView).inset(50)
            $0.top.equalTo(petTypeTxtFld.snp.bottom).inset(-10)
        }
        self.petGenderTxtFld.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.width.equalTo(self.contentView).inset(50)
            $0.top.equalTo(petBreedTxtFld.snp.bottom).inset(-10)
        }
        self.petMissingAdressTxtFld.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.width.equalTo(self.contentView).inset(50)
            $0.top.equalTo(petGenderTxtFld.snp.bottom).inset(-10)
        }
        self.petAdditionalInfoTxtFld.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.width.equalTo(self.contentView).inset(50)
            $0.top.equalTo(petMissingAdressTxtFld.snp.bottom).inset(-10)
        }
        self.phoneTxtFld.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.width.equalTo(self.contentView).inset(50)
            $0.top.equalTo(petAdditionalInfoTxtFld.snp.bottom).inset(-10)
        }
        self.editBtn.snp.makeConstraints {
            $0.top.equalTo(self.phoneTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        self.deleteBtn.snp.makeConstraints {
            $0.top.equalTo(self.editBtn.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
            $0.bottom.equalTo(self.contentView)
        }
    }
    
    @objc private func editBtnTapped() {
        Firestore.firestore().collection("Missing Animals").document(myPetID).updateData([
            "name": petNameTxtFld.text ?? "",
            "type": petTypeTxtFld.text ?? "",
            "breed": petBreedTxtFld.text ?? "",
            "gender": petGenderTxtFld.text ?? "",
            "missingAddress": petMissingAdressTxtFld.text ?? "",
            "additionalInfo": petAdditionalInfoTxtFld.text ?? "",
            "phone": phoneTxtFld.text ?? "",]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        let alert = UIAlertController(title: "Изменено успешно", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    @objc private func deleteBtnTapped() {
        Firestore.firestore().collection("Missing Animals").document(myPetID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                let alert = UIAlertController(title: "Запись удалена успешно", message: nil, preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "OK", style: .default) { (alert) in
                    self.dismiss(animated: true, completion: nil)
                    MyAnnounsVC.shared.tableView.reloadData()
                }
                alert.addAction(action)
                self.present(alert, animated: true)
                print("Document successfully removed!")
            }
        }
    }
    
    private func showPetName() {
        Firestore.firestore().collection("Missing Animals").document(myPetID)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                let petName = data["name"] as? String ?? "UnidentifiedUser"
                self.navigationItem.title = petName
                print("User name = \(petName)")
            }
    }
    
}

extension MyAnnouncEditVC {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if petGenderTxtFld.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
            if petMissingAdressTxtFld.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
            if petAdditionalInfoTxtFld.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
            if phoneTxtFld.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
}
