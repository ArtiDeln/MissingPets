//
//  VetMap.swift
//  MissingPets
//
//  Created by Artyom Butorin on 30.05.22.
//

import Foundation
import UIKit
import MapKit

class Vets: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var name: String
    var jobTime: String
    var title: String? {
        return name
    }
    
    init(name: String, jobTime: String,coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.jobTime = jobTime
        self.coordinate = coordinate
    }
}
