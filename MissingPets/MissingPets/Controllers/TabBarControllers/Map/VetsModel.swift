//
//  VetsModel.swift
//  MissingPets
//
//  Created by Artyom Butorin on 30.05.22.
//

import Foundation
import UIKit
import MapKit

class VetModel {
    var vets = [[Vets]]()
    init() {
        setup()
    }
    func setup() {
        let vet1 = Vets(name: "Ветдок", jobTime: "09:00 – 21:00", coordinate: CLLocationCoordinate2D(latitude: 52.466969, longitude: 31.042848) )
        let vet2 = Vets(name: "Волотовская ветлечебница", jobTime: "09:00 – 13:00, 14:00 – 18:00", coordinate: CLLocationCoordinate2D(latitude: 52.469376, longitude: 31.024829))
        let vet3 = Vets(name: "ПолиВет", jobTime: "09:00 – 20:30", coordinate: CLLocationCoordinate2D(latitude: 52.455618, longitude: 31.020820))
        let vet4 = Vets(name: "Три Вет", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.451782, longitude: 31.014766))
        let vet5 = Vets(name: "Ветеринарная клиника", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.462108, longitude: 30.985957))
        let vet6 = Vets(name: "ВетАмика", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.467449, longitude: 30.970774))
        let vet7 = Vets(name: "Доктор Айболит", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.434127, longitude: 31.010172))
        let vet8 = Vets(name: "Зооидеал", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.427211, longitude: 31.002328))
        let vet9 = Vets(name: "Гомельская городская ветеринарная станция", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.424344, longitude: 31.001450))
        let vet10 = Vets(name: "Микродруг", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.417884, longitude: 30.980199))
        let vet11 = Vets(name: "Ветеринарный кабинет", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.407500, longitude: 30.957277))
        let vet12 = Vets(name: "Ветеринарная лечебница Советского района", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.410090, longitude: 30.927691))
        let vet13 = Vets(name: "ПолиВет", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.405334, longitude: 30.910310))
        let vet14 = Vets(name: "Новобелицкая Ветлечебница", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.385325, longitude: 31.030590))
        let vet15 = Vets(name: "Гомельская районная ветеринарная станция", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.366987, longitude: 31.026302))
        let vet16 = Vets(name: "КоТи", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.356455, longitude: 31.028892))
        let vet17 = Vets(name: "Ваш питомец", jobTime: "", coordinate: CLLocationCoordinate2D(latitude: 52.359540, longitude: 31.033550))
        let array = [vet1,vet2,vet3,vet4,vet5,vet6,vet7,vet8,vet9,vet10,vet11,vet12,vet13,vet14,vet15,vet16,vet17]
        
        vets.append(array)
    }
}
