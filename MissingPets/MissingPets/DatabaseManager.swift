//
//  DatabaseManager.swift
//  MissingPets
//
//  Created by Artyom Butorin on 1.06.22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func insertAnnounc(with pet: MissingPetsAnnounc) {
        database.child(pet.petName).setValue(["name": pet.petName])
    }
}

struct MissingPetsAnnounc {
//    let petType: String
    let petName: String
//    let petImage: String
}
