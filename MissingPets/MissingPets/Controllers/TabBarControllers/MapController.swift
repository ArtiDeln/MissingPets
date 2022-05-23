//
//  MapController.swift
//  MissingPets
//
//  Created by Artyom Butorin on 18.05.22.
//

import UIKit
import MapKit
import SnapKit

class MapVC: UIViewController, MKMapViewDelegate {

    private let mapView: MKMapView = {
            let mapView = MKMapView()
            mapView.translatesAutoresizingMaskIntoConstraints = false
            return mapView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.navigationItem.title = "Карта ветклиник"
        self.view.addSubview(self.mapView)
        self.mapView.delegate = self

        self.mapView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
            $0.edges.equalTo(self.view)
        }
    }
    
}

extension MapVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }

}
