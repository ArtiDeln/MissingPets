//
//  Service.swift
//  MissingPets
//
//  Created by Artyom Butorin on 3.06.22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class Service {
    
    static let shared = Service()
    
    func getMissingPetsData(completion: @escaping ([MissingPetsData]) -> ()) {
        
        Firestore.firestore().collection("Missing Animals").whereField("status", isEqualTo: "missing").getDocuments { snap, err in
            if err == nil {
                var petList = [MissingPetsData]()
                if let docs = snap?.documents {
                    for doc in docs {
                        let data = doc.data()
                        var imgData = Data()
                        if let url = URL(string: data["photo"] as? String ?? "No photo") {
                            do {
                                let dataImage: Data = try Data(contentsOf: url)
                                imgData = dataImage
                            } catch {
                                print(error)
                            }
                        }
                        let name = data["name"] as? String ?? "Неизвестна"
                        let phone = data["phone"] as? String ?? "Неизвестен"
                        let breed = data["breed"] as? String ?? "Неизвестно"
                        let type = data["type"] as? String ?? "Неизвестен"
                        let gender = data["gender"] as? String ?? "Неизвестен"
                        let missingAddress = data["missingAddress"] as? String ?? "Неизвестен"
                        let additionalInfo = data["additionalInfo"] as? String ?? "Отсутствует"
                        
                        petList.append(MissingPetsData(petPhoto: UIImage(data: imgData)!,
                                                       petName: name,
                                                       petBreed: breed,
                                                       petType: type,
                                                       petGender: gender,
                                                       missingAddress: missingAddress,
                                                       additionalInfo: additionalInfo,
                                                       phone: phone))
                    }
                }
                completion(petList)
            }
        }
    }
    
    func getFoundedPetsData(completion: @escaping ([FoundedPetsData]) -> ()) {
        
        Firestore.firestore().collection("Missing Animals").whereField("status", isEqualTo: "founded").getDocuments { snap, err in
            if err == nil {
                var petList = [FoundedPetsData]()
                if let docs = snap?.documents {
                    for doc in docs {
                        let data = doc.data()
                        var imgData = Data()
                        if let url = URL(string: data["photo"] as? String ?? "No photo") {
                            do {
                                let dataImage: Data = try Data(contentsOf: url)
                                imgData = dataImage
                            } catch {
                                print(error)
                            }
                        }
                        let name = data["name"] as? String ?? "Неизвестна"
                        let phone = data["phone"] as? String ?? "Неизвестен"
                        let breed = data["breed"] as? String ?? "Неизвестно"
                        let type = data["type"] as? String ?? "Неизвестен"
                        let gender = data["gender"] as? String ?? "Неизвестен"
                        let missingAddress = data["missingAddress"] as? String ?? "Неизвестен"
                        let additionalInfo = data["additionalInfo"] as? String ?? "Отсутствует"
                        
                        petList.append(FoundedPetsData(petPhoto: UIImage(data: imgData)!,
                                                       petName: name,
                                                       petBreed: breed,
                                                       petType: type,
                                                       petGender: gender,
                                                       missingAddress: missingAddress,
                                                       additionalInfo: additionalInfo,
                                                       phone: phone))
                    }
                }
                completion(petList)
            }
        }
    }
    
    func getMyPetsData(completion: @escaping ([MyPetsData]) -> ()) {
        
        let user = Auth.auth().currentUser

        Firestore.firestore().collection("Missing Animals").whereField("owner", isEqualTo: "\(user!.uid)").getDocuments { snap, err in
            if err == nil {
                var petList = [MyPetsData]()
                if let docs = snap?.documents {
                    for doc in docs {
                        let data = doc.data()
                        var imgData = Data()
                        if let url = URL(string: data["photo"] as? String ?? "No photo") {
                            do {
                                let dataImage: Data = try Data(contentsOf: url)
                                imgData = dataImage
                            } catch {
                                print(error)
                            }
                        }
                        let name = data["name"] as? String ?? "Неизвестна"
                        let phone = data["phone"] as? String ?? "Неизвестен"
                        let breed = data["breed"] as? String ?? "Неизвестно"
                        let type = data["type"] as? String ?? "Неизвестен"
                        let gender = data["gender"] as? String ?? "Неизвестен"
                        let missingAddress = data["missingAddress"] as? String ?? "Неизвестен"
                        let additionalInfo = data["additionalInfo"] as? String ?? "Отсутствует"
                        
                        petList.append(MyPetsData(petPhoto: UIImage(data: imgData)!,
                                                       petName: name,
                                                       petBreed: breed,
                                                       petType: type,
                                                       petGender: gender,
                                                       missingAddress: missingAddress,
                                                       additionalInfo: additionalInfo,
                                                       phone: phone))
                    }
                }
                completion(petList)
            }
        }
    }
    
}

struct MissingPetsData {
    var petPhoto: UIImage
    var petName: String
    var petBreed: String
    var petType: String
    var petGender: String
    var missingAddress: String
    var additionalInfo: String
    var phone: String
}

struct FoundedPetsData {
    var petPhoto: UIImage
    var petName: String
    var petBreed: String
    var petType: String
    var petGender: String
    var missingAddress: String
    var additionalInfo: String
    var phone: String
}

struct MyPetsData {
    var petPhoto: UIImage
    var petName: String
    var petBreed: String
    var petType: String
    var petGender: String
    var missingAddress: String
    var additionalInfo: String
    var phone: String
}
