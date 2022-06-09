//
//  MyAnnounceVC.swift
//  MissingPets
//
//  Created by Artyom Butorin on 31.05.22.
//

import UIKit

class MyAnnounceVC: UIViewController {

    //TODO: - Удаление и изменение объявлений
    
    static let shared = MyAnnounceVC()
    
    private(set) lazy var myPetsData = [MyPetsData]()
    
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
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Мои объявления"
        
        self.view.addSubview(tableView)
        self.tableView.refreshControl = myRefreshControl
        
        self.myRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.setTableViewSettings()
        self.getMyPetsData()
    }
    
    //MARK: - @objc funcs
    
    @objc private func refresh(sender: UIRefreshControl) {
        self.getMyPetsData()
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
    
    func getMyPetsData() {
        Service.shared.getMyPetsData { myPetsData in
            self.myPetsData = myPetsData
            self.tableView.reloadData()
        }
    }
}

extension MyAnnounceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPetsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.dataMyP = myPetsData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let rootVC = MyAnnounceEditVC()
        let navVC = UINavigationController(rootViewController: rootVC)
        
        rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад",
                                                                  style: .done,
                                                                  target: self,
                                                                  action: #selector(backBtnTapped))
        
        rootVC.petPhotoImg.image = myPetsData[indexPath.row].petPhoto
        rootVC.petNameTxtFld.text = myPetsData[indexPath.row].petName
        rootVC.petTypeTxtFld.text = myPetsData[indexPath.row].petType
        rootVC.petBreedTxtFld.text = myPetsData[indexPath.row].petBreed
        rootVC.petGenderTxtFld.text = myPetsData[indexPath.row].petGender
        rootVC.petAdditionalInfoTxtFld.text = myPetsData[indexPath.row].additionalInfo
        rootVC.petMissingAdressTxtFld.text = myPetsData[indexPath.row].missingAddress
        rootVC.phoneTxtFld.text = myPetsData[indexPath.row].phone
        rootVC.myPetID = myPetsData[indexPath.row].petID
        
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
