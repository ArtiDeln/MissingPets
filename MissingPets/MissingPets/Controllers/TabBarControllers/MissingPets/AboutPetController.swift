//
//  AboutPetController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 6.06.22.
//

import UIKit

class AboutPetController: UIViewController, UIScrollViewDelegate {
    
    public lazy var number = String()

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
        self.phoneBtn.snp.makeConstraints {
            $0.top.equalTo(petTypeLbl.snp.bottom).offset(10)
            $0.width.equalTo(self.contentView).inset(50)
            $0.centerX.equalTo(self.contentView)
            $0.bottom.equalTo(self.contentView).offset(-20)
        }
    }

    @objc func callNumber() {
//        print(number)
        print("TEST!!!!")
        guard let number = URL(string: "tel://" + number) else { return }
        UIApplication.shared.open(number)
    }
    
}
