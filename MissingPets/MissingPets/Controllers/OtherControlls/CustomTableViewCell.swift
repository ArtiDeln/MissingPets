//
//  CustomTableViewCell.swift
//  MissingPets
//
//  Created by Artyom Butorin on 4.06.22.
//

import UIKit
import SnapKit

class CustomTableViewCell : UITableViewCell {
        
    var dataMP : MissingPetsData? {
        didSet {
            petNameTitleLbl.text = "Кличка: \(dataMP!.petName)"
            dataMissingAddressLbl.text = "Адрес: \(dataMP!.missingAddress)"
            dataImage.image = dataMP?.petPhoto
            breedLbl.text = "Порода: \(dataMP!.petBreed)"
        }
    }
    
    var dataFP : FoundedPetsData? {
        didSet {
            petNameTitleLbl.text = "Кличка: \(dataFP!.petName)"
            dataMissingAddressLbl.text = "Адрес: \(dataFP!.missingAddress)"
            dataImage.image = dataFP?.petPhoto
            breedLbl.text = "Порода: \(dataFP!.petBreed)"
        }
    }
    
    private(set) lazy var breedLbl: UILabel = {
        let phone = UILabel()
        phone.textAlignment = .left
        return phone
    }()
    
    private let petNameTitleLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dataMissingAddressLbl: UILabel = {
        let label = UILabel()
//        label.textColor = .lightGray
//        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private var dataImage: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.contentMode = .scaleAspectFit
//        imageView.image = imageView.image?.withRenderingMode(.automatic)
        imageView.tintColor = UIColor.gray
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initView()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.addSubview(self.dataImage)
        self.addSubview(self.petNameTitleLbl)
        self.addSubview(self.breedLbl)
        self.addSubview(self.dataMissingAddressLbl)
    }
    
    private func constraints() {
        self.petNameTitleLbl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        self.dataImage.snp.makeConstraints {
            $0.top.equalTo(self.petNameTitleLbl.snp.bottom)
            $0.left.equalToSuperview().inset(10)
            $0.size.equalTo(80)
        }
        self.breedLbl.snp.makeConstraints {
            $0.left.equalTo(self.dataImage.snp.right).inset(-10)
            $0.top.equalTo(self.petNameTitleLbl.snp.bottom).inset(-10)
        }
        
        self.dataMissingAddressLbl.snp.makeConstraints {
            $0.left.equalTo(self.dataImage.snp.right).inset(-10)
            $0.top.equalTo(self.breedLbl.snp.bottom).inset(-10)
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
