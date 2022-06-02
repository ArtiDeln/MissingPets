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

class AddPetVC: UIViewController {
    
    let status = ["Пропал", "Найден"]
    
    //MARK: - GUI
    
    private(set) lazy var petImgView: UIImageView = {
        let petPhoto = UIImageView()
        petPhoto.image = UIImage(named: "AddPhotoImage")
        //        petPhoto.contentMode = .scaleAspectFit
        petPhoto.layer.borderWidth = 1
        petPhoto.layer.borderColor = UIColor.gray.cgColor
        petPhoto.isUserInteractionEnabled = true
        petPhoto.layer.cornerRadius = 10
        petPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPhotoActionSheet)))
        return petPhoto
    }()
    
    private(set) lazy var test1: UISegmentedControl = {
        let segment = UISegmentedControl(items: status)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(didSegmentValueChange), for: .valueChanged)
        return segment
    }()
    
    private(set) lazy var petNicknameTxtFld: UITextField = {
        let nickname = UITextField()
        nickname.borderStyle = .roundedRect
        nickname.placeholder = "Имя"
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
    
    private(set) lazy var petOwnerPhoneTxtFld: UITextField = {
        let petOwnerPhone = UITextField()
        petOwnerPhone.borderStyle = .roundedRect
        petOwnerPhone.placeholder = "Телефон владельца"
        petOwnerPhone.autocapitalizationType = .none
        return petOwnerPhone
    }()
    
    private(set) lazy var additionaDescriptionTxtFld: UITextField = {
        let additionaDescription = UITextField()
        additionaDescription.borderStyle = .roundedRect
        additionaDescription.placeholder = "Доп. описание"
        additionaDescription.autocapitalizationType = .none
        return additionaDescription
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
        
        //        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Разместить объявление"
        
        self.view.backgroundColor = .systemBackground
        
        self.initView()
        
        self.constraints()
    }
    
    //MARK: - Initialization
    
    func initView() {
        self.view.addSubview(petImgView)
        self.view.addSubview(test1)
        self.view.addSubview(petNicknameTxtFld)
        self.view.addSubview(petTypeTxtFld)
        self.view.addSubview(petBreedTxtFld)
        self.view.addSubview(petGenderTxtFld)
        self.view.addSubview(petMissingAddressTxtFld)
        self.view.addSubview(petOwnerPhoneTxtFld)
        self.view.addSubview(additionaDescriptionTxtFld)
        self.view.addSubview(publishBtn)
    }
    
    //MARK: - @objc functions
    
    var variable = String()
    
    @objc func didSegmentValueChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: variable = "Пропал"
        case 1: variable = "Найден"
        default: variable = "Пропал"
        }
    }
    
    
    
    @objc func didPublishBtnTapped() {
        petNicknameTxtFld.resignFirstResponder()
        petTypeTxtFld.resignFirstResponder()
        petBreedTxtFld.resignFirstResponder()
        petGenderTxtFld.resignFirstResponder()
        petMissingAddressTxtFld.resignFirstResponder()
        petOwnerPhoneTxtFld.resignFirstResponder()
        additionaDescriptionTxtFld.resignFirstResponder()
        
        guard let petNickname = petNicknameTxtFld.text,
              let petType = petTypeTxtFld.text,
              let petBreed = petBreedTxtFld.text,
              let petGender = petGenderTxtFld.text,
              let petMissingAddress = petMissingAddressTxtFld.text,
              let petOwnerPhone = petOwnerPhoneTxtFld.text,
              let additionalDescription = additionaDescriptionTxtFld.text,
              !petNickname.isEmpty,
              !petType.isEmpty,
              !petBreed.isEmpty,
              !petGender.isEmpty,
              !petMissingAddress.isEmpty,
              !petOwnerPhone.isEmpty else { return }
        //                DatabaseManager.shared.insertAnnounc(with: MissingPetsAnnounc(petName: petNickname))
        
//        ref.child("Test iOS Missing Animals").childByAutoId().setValue(["Name": petNickname,
//                                                                        "Type": petType,
//                                                                        "Breed": petBreed,
//                                                                        "Gender": petGender,
//                                                                        "MissingAddress": petMissingAddress,
//                                                                        "OwnerPhone": petOwnerPhone,
//                                                                        "AdditionalDescription": additionalDescription])
        //        ref.child("Test iOS Missing Animals").childByAutoId().setValue(["Type": petType])
        //        ref.child("Test iOS Missing Animals").childByAutoId().setValue(["Breed": petBreed])
        //        ref.child("Test iOS Missing Animals").childByAutoId().setValue(["Gender": petGender])
        //        ref.child("Test iOS Missing Animals").childByAutoId().setValue(["MissingAddress": petMissingAddress])
        //        ref.child("Test iOS Missing Animals").childByAutoId().setValue(["OwnerPhone": petOwnerPhone])
        //        ref.child("Test iOS Missing Animals").childByAutoId().setValue(["AdditionalDescription": additionalDescription])
        
        uploadPetPhoto(photo: petImgView.image!) { (result) in
            switch result {
            case .success(let url):
                self.ref.child("Test iOS Missing Animals").childByAutoId().setValue(["Photo": url.absoluteString,
                                                                                     "Name": petNickname,
                                                                                     "Type": petType,
                                                                                     "Breed": petBreed,
                                                                                     "Gender": petGender,
                                                                                     "MissingAddress": petMissingAddress,
                                                                                     "OwnerPhone": petOwnerPhone,
                                                                                     "AdditionalDescription": additionalDescription,
                                                                                     "Status": self.variable])
            case .failure:
                return
            }
        }
    }
    
    private func uploadPetPhoto(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = Storage.storage().reference().child("Test iOS Animal Photo").child("\(user?.email ?? "UnidentifiedUser")-\(Date().millisecondsSince1970)")
        
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
    
    //MARK: - Constraints
    
    private func constraints() {
        petImgView.snp.makeConstraints {
            $0.top.equalTo(self.view).inset(100)
            $0.size.equalTo(120)
            $0.centerX.equalTo(self.view)
        }
        petNicknameTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petImgView.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(50)
        }
        petTypeTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petNicknameTxtFld.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(50)
        }
        petBreedTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petTypeTxtFld.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(50)
        }
        petGenderTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petBreedTxtFld.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(50)
        }
        petMissingAddressTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petGenderTxtFld.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(50)
        }
        petOwnerPhoneTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petMissingAddressTxtFld.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(50)
        }
        additionaDescriptionTxtFld.snp.makeConstraints {
            $0.top.equalTo(self.petOwnerPhoneTxtFld.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(50)
        }
        publishBtn.snp.makeConstraints {
            $0.top.equalTo(additionaDescriptionTxtFld.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(50)
        }
        test1.snp.makeConstraints {
            $0.top.equalTo(publishBtn.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
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
