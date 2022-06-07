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
    
    private(set) lazy var missingPetsData = [MissingPetsData]()
    
    //MARK: - GUI
    
    private(set) lazy var myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление")
        return refreshControl
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationItem.title = "Пропавшие питомцы"
        
        self.view.addSubview(tableView)
        self.tableView.refreshControl = myRefreshControl
        
        self.myRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.setTableViewSettings()
        self.getMissingPetsData()
    }
    
    //MARK: - @objc funcs
    
    @objc private func refresh(sender: UIRefreshControl) {
        self.getMissingPetsData()
        sender.endRefreshing()
    }
    
    //MARK: - funcs
    
    func setTableViewSettings() {
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.frame = view.bounds
    }
    
    func getMissingPetsData() {
        Service.shared.getMissingPetsData { missingPetsData in
            self.missingPetsData = missingPetsData
            self.tableView.reloadData()
        }
    }
}

extension MissingPetsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missingPetsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.dataMP = missingPetsData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rootVC = AboutPetController()
        let navVC = UINavigationController(rootViewController: rootVC)
        
        rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад",
                                                                  style: .done,
                                                                  target: self,
                                                                  action: #selector(backBtnTapped))
        
        rootVC.navigationItem.title = "\(self.missingPetsData[indexPath.row].petName)"
        rootVC.petPhotoImg.image = missingPetsData[indexPath.row].petPhoto
        rootVC.petBreedLbl.text = "Порода: \(missingPetsData[indexPath.row].petBreed)"
        rootVC.petGenderLbl.text = "Пол: \(missingPetsData[indexPath.row].petGender)"
        rootVC.petAdditionalInfo.text = missingPetsData[indexPath.row].additionalInfo
        rootVC.petMissingAdressLbl.text = "Адрес пропажи: \(missingPetsData[indexPath.row].missingAddress)"
        rootVC.petTypeLbl.text = missingPetsData[indexPath.row].petType

        rootVC.number = "\(missingPetsData[indexPath.row].phone)"
        
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    @objc private func backBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
