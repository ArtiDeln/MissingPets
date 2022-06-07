//
//  FoundPetsVC.swift
//  MissingPets
//
//  Created by Artyom Butorin on 23.05.22.
//

import UIKit

class FoundPetsVC: UIViewController {
    
    private var collectionView: UICollectionView! = nil
        
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
    }
}

extension FoundPetsVC: UICollectionViewDelegate {
    func collectionView(_ collectiomView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
