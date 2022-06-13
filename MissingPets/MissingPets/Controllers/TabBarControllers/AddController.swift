//
//  ViewController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 18.05.22.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class AddPetVC: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Variable
    
    var photoURL = String()
    var ref: DatabaseReference!
    
    let user = Auth.auth().currentUser
    let status = ["Пропал", "Найден"]
    
    //MARK: - GUI
    
    private(set) lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private(set) lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private(set) lazy var petImgView: UIImageView = {
        let petPhoto = UIImageView()
        petPhoto.image = UIImage(named: "AddPhotoImage")
        petPhoto.contentMode = .scaleAspectFit
        petPhoto.layer.borderWidth = 1
        petPhoto.backgroundColor = .white
        petPhoto.layer.borderColor = UIColor.gray.cgColor
        petPhoto.isUserInteractionEnabled = true
        petPhoto.layer.cornerRadius = 10
        petPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPhotoActionSheet)))
        return petPhoto
    }()
    
    private(set) lazy var switchSgmntdCntrl: UISegmentedControl = {
        let segment = UISegmentedControl(items: status)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(didSegmentValueChange), for: .valueChanged)
        return segment
    }()
    
    private(set) lazy var petNicknameTxtFld: UITextField = {
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        txtFld.clearButtonMode = .whileEditing
        txtFld.placeholder = "Кличка"
        return txtFld
    }()
    
    private(set) lazy var petTypeTxtFld: UITextField = {
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        txtFld.clearButtonMode = .whileEditing
        txtFld.attributedPlaceholder = NSAttributedString(string: "Вид питомца",
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
//        txtFld.placeholder = "Вид питомца"
        return txtFld
    }()
    
    private(set) lazy var petBreedTxtFld: UITextField = {
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        txtFld.clearButtonMode = .whileEditing
        txtFld.placeholder = "Порода"
        return txtFld
    }()
    
    private(set) lazy var petGenderTxtFld: UITextField = {
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        txtFld.clearButtonMode = .whileEditing
        txtFld.placeholder = "Пол"
        return txtFld
    }()
    
    private(set) lazy var petMissingAddressTxtFld: UITextField = {
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        txtFld.clearButtonMode = .whileEditing
        txtFld.attributedPlaceholder = NSAttributedString(string: "Адрес пропажи",
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
//        txtFld.placeholder = "Адрес пропажи"
        return txtFld
    }()
    
    private(set) lazy var phoneNumberTxtFld: UITextField = {
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        txtFld.clearButtonMode = .whileEditing
        txtFld.attributedPlaceholder = NSAttributedString(string: "Телефон владельца",
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
//        txtFld.placeholder = "Телефон владельца"
        txtFld.keyboardType = .numbersAndPunctuation
        return txtFld
    }()
    
    private(set) lazy var additionalInfoTxtFld: UITextField = {
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        txtFld.clearButtonMode = .whileEditing
        txtFld.placeholder = "Доп. информация"
        return txtFld
    }()
    
    private(set) lazy var publishBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Опубликовать", for: .normal)
        btn.addTarget(self, action: #selector(didPublishBtnTapped), for: .touchUpInside)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.navigationItem.title = "Разместить объявление"
        
        self.view.backgroundColor = .systemBackground
        
        self.initView()
        self.constraints()
        
        self.setupHideKeyboardOnTap()
    }
    
    //MARK: - Initialization
    
    func initView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.petImgView)
        self.contentView.addSubview(self.switchSgmntdCntrl)
        self.contentView.addSubview(self.petNicknameTxtFld)
        self.contentView.addSubview(self.petTypeTxtFld)
        self.contentView.addSubview(self.petBreedTxtFld)
        self.contentView.addSubview(self.petGenderTxtFld)
        self.contentView.addSubview(self.petMissingAddressTxtFld)
        self.contentView.addSubview(self.phoneNumberTxtFld)
        self.contentView.addSubview(self.additionalInfoTxtFld)
        self.contentView.addSubview(self.publishBtn)
    }
    
    //MARK: - @objc functions
    
    var petStatus = "missing"
    @objc func didSegmentValueChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: petStatus = "missing"
            phoneNumberTxtFld.placeholder = "Телефон владельца"
            petNicknameTxtFld.placeholder = "Кличка"
            petMissingAddressTxtFld.placeholder = "Адрес пропажи"
        case 1: petStatus = "founded"
            phoneNumberTxtFld.placeholder = "Телефон нашедшего"
            petNicknameTxtFld.placeholder = "Кличка, если известна"
            petMissingAddressTxtFld.placeholder = "Адрес обнаружения"
        default: petStatus = "missing"
        }
    }
    
    @objc func didPublishBtnTapped() {
        petNicknameTxtFld.resignFirstResponder()
        petTypeTxtFld.resignFirstResponder()
        petBreedTxtFld.resignFirstResponder()
        petGenderTxtFld.resignFirstResponder()
        petMissingAddressTxtFld.resignFirstResponder()
        phoneNumberTxtFld.resignFirstResponder()
        additionalInfoTxtFld.resignFirstResponder()
        
        guard let petNickname = petNicknameTxtFld.text,
              let petType = petTypeTxtFld.text,
              let petBreed = petBreedTxtFld.text,
              let petGender = petGenderTxtFld.text,
              let petMissingAddress = petMissingAddressTxtFld.text,
              let phoneNumber = phoneNumberTxtFld.text,
              let additionalInfo = additionalInfoTxtFld.text,
              !petType.isEmpty,
              !petMissingAddress.isEmpty,
              !phoneNumber.isEmpty else {
            errorAlert()
            return
        }
        
        uploadPetPhoto(photo: petImgView.image!) { (result) in
            switch result {
            case .success(let url):
                self.photoURL = url.absoluteString
        
                Firestore.firestore().collection("Missing Animals").addDocument(data: ["photo": self.photoURL,
                                                                                       "name": petNickname,
                                                                                       "type": petType,
                                                                                       "breed": petBreed,
                                                                                       "gender": petGender,
                                                                                       "missingAddress": petMissingAddress,
                                                                                       "phone": phoneNumber,
                                                                                       "additionalInfo": additionalInfo,
                                                                                       "status": self.petStatus,
                                                                                       "owner": self.user!.uid,
                                                                                       "date": Date().toMillis]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        let alert = UIAlertController(title: "Объявление успешно создано", message: nil, preferredStyle: .actionSheet)
                        let action = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(action)
                        self.present(alert, animated: true)
                        print("Document successfully written!")
                        self.clearAllItems()
                    }
                }
                
            case .failure:
                let alert = UIAlertController(title: "Ошибка!", message: nil, preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
                print("error data added")
                return
            }
        }
    }
    
    private func clearAllItems() {
        self.petImgView.image = UIImage(named: "AddPhotoImage")
        self.petNicknameTxtFld.text = ""
        self.petTypeTxtFld.text = ""
        self.petBreedTxtFld.text = ""
        self.petGenderTxtFld.text = ""
        self.petMissingAddressTxtFld.text = ""
        self.phoneNumberTxtFld.text = ""
        self.additionalInfoTxtFld.text = ""
    }
    
    private func uploadPetPhoto(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = Storage.storage().reference().child("Animal Images").child("\(user?.email ?? "UnidentifiedUser")-\(Date().toMillis)")
        
        guard let imageData = petImgView.image?.jpegData(compressionQuality: 0.5) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metadata) { (metadata, error) in
            guard metadata != nil else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
    
    func errorAlert() {
        let alertController = UIAlertController(title: "Заполните обязательные поля",
                                                message: "Обязательные поля выделены красным цветом",
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default,
                                   handler: .none)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Constraints
    
    private func constraints() {
        self.scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view)
        }
        self.contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView)
            $0.width.equalTo(self.view)
        }
        self.petImgView.snp.makeConstraints {
            $0.top.equalTo(self.contentView)
            $0.size.equalTo(120)
            $0.centerX.equalTo(self.contentView)
        }
        self.switchSgmntdCntrl.snp.makeConstraints {
            $0.top.equalTo(self.petImgView.snp.bottom).offset(10)
            $0.width.equalTo(200)
            $0.centerX.equalTo(self.contentView)
        }
        self.petNicknameTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.switchSgmntdCntrl.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        self.petTypeTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petNicknameTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        self.petBreedTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petTypeTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        self.petGenderTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petBreedTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        self.petMissingAddressTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petGenderTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        self.phoneNumberTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petMissingAddressTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        self.additionalInfoTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.phoneNumberTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        self.publishBtn.snp.makeConstraints {
            $0.top.equalTo(self.additionalInfoTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
            $0.bottom.equalTo(self.contentView).offset(-20)
        }
    }
}

extension AddPetVC {
    
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
            if petMissingAddressTxtFld.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
            if phoneNumberTxtFld.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
            if additionalInfoTxtFld.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
}
