//
//  AboutPetController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 6.06.22.
//

import UIKit

class AboutPetController: UIViewController, UIScrollViewDelegate {
    
    public lazy var number = String()
    
    //MARK: -GUI

    private(set) lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()

    private(set) lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()

    private(set) var petPhotoImg: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.gray
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()

    private(set) var petTypeLbl: UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 20)
        return name
    }()
    
    private(set) var petBreedLbl: UILabel = {
        let breed = UILabel()
        breed.font = UIFont.boldSystemFont(ofSize: 14)
        return breed
    }()
    
    private(set) var petGenderLbl: UILabel = {
        let gender = UILabel()
        gender.font = UIFont.boldSystemFont(ofSize: 14)
        return gender
    }()
    
    private(set) var petMissingAdressLbl: UILabel = {
        let missingAddress = UILabel()
        missingAddress.font = UIFont.boldSystemFont(ofSize: 14)
        return missingAddress
    }()
    
    private(set) var petAdditionalInfo: UILabel = {
        let additionalInfo = UILabel()
        additionalInfo.font = UIFont.boldSystemFont(ofSize: 14)
        return additionalInfo
    }()

    private(set) var phoneBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Позвонить", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground

        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.phoneBtn.addTarget(self, action: #selector(callNumber), for: .touchUpInside)

        self.initView()
        self.constraints()
    }

    private func initView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(self.petPhotoImg)
        self.contentView.addSubview(self.petTypeLbl)
        self.contentView.addSubview(self.petBreedLbl)
        self.contentView.addSubview(self.petGenderLbl)
        self.contentView.addSubview(self.petMissingAdressLbl)
        self.contentView.addSubview(self.petAdditionalInfo)
        self.contentView.addSubview(self.phoneBtn)
    }

    private func constraints() {
        self.scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view)
        }
        self.contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView)
            $0.width.equalTo(self.view)
        }
        self.petPhotoImg.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(contentView)
            $0.size.equalTo(250)
        }
        self.petTypeLbl.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(petPhotoImg.snp.bottom).inset(-10)
        }
        self.petBreedLbl.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(petTypeLbl.snp.bottom).inset(-10)
        }
        self.petGenderLbl.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(petBreedLbl.snp.bottom).inset(-10)
        }
        self.petMissingAdressLbl.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(petGenderLbl.snp.bottom).inset(-10)
        }
        self.petAdditionalInfo.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(petMissingAdressLbl.snp.bottom).inset(-10)
        }
        self.phoneBtn.snp.makeConstraints {
            $0.top.equalTo(petAdditionalInfo.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
            $0.bottom.equalTo(self.contentView).offset(-20)
        }
    }

    @objc func callNumber() {
        print("Call button tapped")
        guard let number = URL(string: "tel://" + number) else { return }
        UIApplication.shared.open(number)
    }
    
}
