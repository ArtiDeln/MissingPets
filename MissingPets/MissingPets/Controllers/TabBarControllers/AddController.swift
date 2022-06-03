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
    
    private(set) lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private(set) lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    let status = ["Пропал", "Найден"]
    
    //MARK: - GUI
    
    private(set) lazy var petImgView: UIImageView = {
        let petPhoto = UIImageView()
        petPhoto.image = UIImage(named: "AddPhotoImage")
        petPhoto.contentMode = .scaleAspectFit
        petPhoto.layer.borderWidth = 1
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
        let nickname = UITextField()
        nickname.borderStyle = .roundedRect
        nickname.placeholder = "Кличка"
        nickname.autocapitalizationType = .none
        return nickname
    }()
    
    private(set) lazy var petTypeTxtFld: UITextField = {
        let petType = UITextField()
        petType.borderStyle = .roundedRect
        petType.placeholder = "Вид питомца"
        petType.autocapitalizationType = .none
        return petType
    }()
    
    private(set) lazy var petBreedTxtFld: UITextField = {
        let petBreed = UITextField()
        petBreed.borderStyle = .roundedRect
        petBreed.placeholder = "Порода"
        petBreed.autocapitalizationType = .none
        return petBreed
    }()
    
    private(set) lazy var petGenderTxtFld: UITextField = {
        let petGender = UITextField()
        petGender.borderStyle = .roundedRect
        petGender.placeholder = "Пол"
        petGender.autocapitalizationType = .none
        return petGender
    }()
    
    private(set) lazy var petMissingAddressTxtFld: UITextField = {
        let petMissingAddress = UITextField()
        petMissingAddress.borderStyle = .roundedRect
        petMissingAddress.placeholder = "Адрес пропажи"
        petMissingAddress.autocapitalizationType = .none
        return petMissingAddress
    }()
    
    private(set) lazy var phoneNumberTxtFld: UITextField = {
        let phoneNumber = UITextField()
        phoneNumber.borderStyle = .roundedRect
        phoneNumber.placeholder = "Телефон владельца"
        phoneNumber.autocapitalizationType = .none
        return phoneNumber
    }()
    
    private(set) lazy var additionalInfoTxtFld: UITextField = {
        let additionalInfo = UITextField()
        additionalInfo.borderStyle = .roundedRect
        additionalInfo.placeholder = "Доп. информация"
        additionalInfo.autocapitalizationType = .none
        return additionalInfo
    }()
    
    private(set) lazy var publishBtn: UIButton = {
        let publish = UIButton()
        publish.setTitle("Опубликовать", for: .normal)
        publish.addTarget(self, action: #selector(didPublishBtnTapped), for: .touchUpInside)
        publish.backgroundColor = .systemBlue
        publish.layer.cornerRadius = 10
        return publish
    }()
    
    //MARK: - ViewDidLoad
    
    var ref: DatabaseReference!
    
    let user = Auth.auth().currentUser
    
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
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(petImgView)
        self.contentView.addSubview(switchSgmntdCntrl)
        self.contentView.addSubview(petNicknameTxtFld)
        self.contentView.addSubview(petTypeTxtFld)
        self.contentView.addSubview(petBreedTxtFld)
        self.contentView.addSubview(petGenderTxtFld)
        self.contentView.addSubview(petMissingAddressTxtFld)
        self.contentView.addSubview(phoneNumberTxtFld)
        self.contentView.addSubview(additionalInfoTxtFld)
        self.contentView.addSubview(publishBtn)
    }
    
    //MARK: - @objc functions
    
    var variable = "missing"
    @objc func didSegmentValueChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: variable = "missing"
            phoneNumberTxtFld.placeholder = "Телефон владельца"
            petNicknameTxtFld.isHidden = false
        case 1: variable = "founded"
            phoneNumberTxtFld.placeholder = "Телефон нашедшего"
            petNicknameTxtFld.isHidden = true
        default: variable = "missing"
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
              !petNickname.isEmpty,
              !petType.isEmpty,
              !petBreed.isEmpty,
              !petGender.isEmpty,
              !petMissingAddress.isEmpty,
              !phoneNumber.isEmpty else {
            errorAlert()
            return
        }
        
        uploadPetPhoto(photo: petImgView.image!) { (result) in
            switch result {
            case .success(let url):
                Firestore.firestore().collection("Test iOS Missing Animals").addDocument(data: ["photo": url.absoluteString,
                                                                                                "name": petNickname,
                                                                                                "type": petType,
                                                                                                "breed": petBreed,
                                                                                                "gender": petGender,
                                                                                                "missingAddress": petMissingAddress,
                                                                                                "phone": phoneNumber,
                                                                                                "additionalInfo": additionalInfo,
                                                                                                "status": self.variable,
                                                                                                "owner": self.user!.uid]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                
//                self.ref.child("Test iOS Missing Animals").childByAutoId().setValue(["photo": url.absoluteString,
//                                                                                     "name": petNickname,
//                                                                                     "type": petType,
//                                                                                     "breed": petBreed,
//                                                                                     "gender": petGender,
//                                                                                     "missingAddress": petMissingAddress,
//                                                                                     "phone": phoneNumber,
//                                                                                     "additionalInfo": additionalInfo,
//                                                                                     "status": self.variable,
//                                                                                     "owner": self.user?.uid])
            case .failure:
                print("error data added")
                return
            }
        }
        clearAllItems()
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
        let ref = Storage.storage().reference().child("Test iOS Animal Photo").child("\(user?.email ?? "UnidentifiedUser")-\(Date().toMillis)")
        
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
        let alertController = UIAlertController(title: "Заполните все поля!",
                                                message: "Поле доп. информация не обязательна к заполнению",
                                                preferredStyle: .alert)
        let action          = UIAlertAction(title: "OK",
                                            style: .default,
                                            handler: .none)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Constraints
    
    private func constraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view)
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView)
            $0.width.equalTo(self.view)
        }
        petImgView.snp.makeConstraints {
            $0.top.equalTo(self.contentView)
            $0.size.equalTo(120)
            $0.centerX.equalTo(self.contentView)
        }
        switchSgmntdCntrl.snp.makeConstraints {
            $0.top.equalTo(petImgView.snp.bottom).offset(10)
            $0.width.equalTo(200)
            $0.centerX.equalTo(self.contentView)
        }
        petNicknameTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.switchSgmntdCntrl.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        petTypeTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petNicknameTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        petBreedTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petTypeTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        petGenderTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petBreedTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        petMissingAddressTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petGenderTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        phoneNumberTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petMissingAddressTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        additionalInfoTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.phoneNumberTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
        }
        publishBtn.snp.makeConstraints {
            $0.top.equalTo(additionalInfoTxtFld.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
            $0.bottom.equalTo(self.contentView).offset(-20)
        }
    }
}

//MARK: - Choose pet picture

extension AddPetVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Выберите фото", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Выбрать фото", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        print(info)
        
        self.petImgView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
