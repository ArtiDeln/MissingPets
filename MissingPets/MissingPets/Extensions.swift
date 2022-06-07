//
//  Extensions.swift
//  MissingPets
//
//  Created by Artyom Butorin on 2.06.22.
//

import Foundation
import UIKit

extension Date {
    
    var toMillis: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }
    
}

extension UIViewController {
    
    //MARK: - Hide keyboard
    
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    //MARK: - Check size screen for adding large title
    //https://overcoder.net/q/104736/%D0%BA%D0%B0%D0%BA-%D0%BF%D1%80%D0%BE%D0%B2%D0%B5%D1%80%D0%B8%D1%82%D1%8C-%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D1%8C-iphone-%D1%81-%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D1%8C%D1%8E-swift#:~:text=%D0%9F%D0%BE%D0%B4%D0%B4%D0%B5%D1%80%D0%B6%D0%BA%D0%B0%20Swift%204%20%2B%20iPhone%20Xr%2C%20Xs%2C%20Xs%20Max
    
    enum UIUserInterfaceIdiom : Int {
        case Unspecified
        case phone
        case pad
    }

    struct ScreenSize {
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        static let screenMaxLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
        static let screenMinLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
    }

    struct DeviceType {
        static let iPhoneSE3Gen = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength <= 667.0
    }
    
    func checkScreenForLargeTitle(){
        if DeviceType.iPhoneSE3Gen {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            self.navigationController?.navigationBar.prefersLargeTitles = true
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

