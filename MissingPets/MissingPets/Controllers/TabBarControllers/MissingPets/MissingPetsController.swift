//
//  MainController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 18.05.22.
//

import UIKit
import Firebase
import FirebaseFirestore

class MissingPetsVC: UIViewController {
    
        static let shared = MissingPetsVC()

    
    let tableView = UITableView()
    
    private(set) lazy var data = [MissingPetsData]()
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground

        self.navigationItem.title = "Пропавшие питомцы"
        view.addSubview(tableView)
        self.setTableViewSettings()
        testing()

    }

    func setTableViewSettings() {
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.frame = view.bounds
    }
    
    //TODO: - Custom TableViewCell and TableView
    func testing() {
        
        Firestore.firestore().collection("Missing Animals").whereField("status", isEqualTo: "missing").addSnapshotListener() { (querySnapshot, err) in
            if err == nil {
                if let docs = querySnapshot?.documents {
                    for doc in docs {
                        let data = doc.data()
                        
                        if let url = URL(string: data["photo"] as? String ?? "No photo") {
                                    do {
                                        let dataImage: Data = try Data(contentsOf: url)
                                        let name = data["name"] as? String ?? "Неизвестна"
                                        let phone = data["phone"] as? String ?? "Неизвестен"
                                        let breed = data["breed"] as? String ?? "Неизвестно"
                                        let type = data["type"] as? String ?? "Неизвестен"
                                        let missingAddress = data["missingAddress"] as? String ?? "Неизвестен"
                                        let additionalInfo = data["additionalInfo"] as? String ?? "Отсутствует"
                                        self.data.append(MissingPetsData(petPhoto: UIImage(data: dataImage)!,
                                                                         petName: name,
                                                                         petBreed: breed,
                                                                         petType: type,
                                                                         missingAddress: missingAddress,
                                                                         additionalInfo: additionalInfo,
                                                                         phone: phone))
                                    } catch {
                                        print(error)
                                    }
                                }
                        
//                        print("imageData: = \(imageData)")
//                        let name = data["name"] as? String ?? "Not Find"
//                        let phone = data["phone"] as? String ?? "No Phone"
//                        self.data.append(Dataa(image: UIImage(data: imgData)!,title: "\(name)" ,description: "\(phone)"))
//                        print(name)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
}
//MARK: -

extension MissingPetsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rootVC = AboutPetController()
        let navVC = UINavigationController(rootViewController: rootVC)
        
        rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(backBtnTapped))

        rootVC.navigationItem.title = "\(self.data[indexPath.row].petName)"
        rootVC.petPhotoImg.image = data[indexPath.row].petPhoto
        rootVC.petTypeLbl.text = "\(data[indexPath.row].petType)"
        rootVC.number = "\(data[indexPath.row].phone)"
        
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    @objc private func backBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
