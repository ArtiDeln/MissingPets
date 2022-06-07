//
//  FoundPetsVC.swift
//  MissingPets
//
//  Created by Artyom Butorin on 23.05.22.
//

import UIKit

class FoundPetsVC: UIViewController {
    
    static let shared = FoundPetsVC()
    
    private(set) lazy var foundedPetsData = [FoundedPetsData]()
    
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
        
        self.navigationItem.title = "Найденные питомцы"
        
        self.view.addSubview(tableView)
        self.tableView.refreshControl = myRefreshControl
        
        self.myRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.setTableViewSettings()
        self.getFoundedPetsData()
    }
    
    //MARK: - @objc funcs
    
    @objc private func refresh(sender: UIRefreshControl) {
        self.getFoundedPetsData()
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
    
    func getFoundedPetsData() {
        Service.shared.getFoundedPetsData { foundedPetsData in
            self.foundedPetsData = foundedPetsData
            self.tableView.reloadData()
        }
    }
}

extension FoundPetsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundedPetsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.dataFP = foundedPetsData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rootVC = AboutPetController()
        let navVC = UINavigationController(rootViewController: rootVC)
        
        rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад",
                                                                  style: .done,
                                                                  target: self,
                                                                  action: #selector(backBtnTapped))
        
        rootVC.navigationItem.title = "\(self.foundedPetsData[indexPath.row].petName)"
        rootVC.petPhotoImg.image = foundedPetsData[indexPath.row].petPhoto
        rootVC.petBreedLbl.text = "Порода: \(foundedPetsData[indexPath.row].petBreed)"
        rootVC.petGenderLbl.text = "Пол: \(foundedPetsData[indexPath.row].petGender)"
        rootVC.petAdditionalInfo.text = foundedPetsData[indexPath.row].additionalInfo
        rootVC.petMissingAdressLbl.text = "Адрес пропажи: \(foundedPetsData[indexPath.row].missingAddress)"
        rootVC.petTypeLbl.text = foundedPetsData[indexPath.row].petType
        rootVC.number = "\(foundedPetsData[indexPath.row].phone)"
        
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
