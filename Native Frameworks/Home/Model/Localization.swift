//
//  Localization.swift
//  Alura Ponto
//
//  Created by Franklin Carvalho on 25/04/23.
//

import Foundation
import CoreLocation

protocol LocalizationDelegate: AnyObject{
    func updateUserLocation(lat: Double?, lng: Double?)
}

class Localization: NSObject {
    
    private var lat: CLLocationDegrees?
    private var lng: CLLocationDegrees?
    
    weak var delegate: LocalizationDelegate?
    
    func getPermission(_ managerLocation: CLLocationManager){
        managerLocation.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            switch managerLocation.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                managerLocation.startUpdatingLocation()
                break
            case .denied:
                //show alert
                break
            case .notDetermined:
                managerLocation.requestWhenInUseAuthorization()
            default:
                break
            }
        }
    }
    
}

extension Localization: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let localization = locations.first {
            lat = localization.coordinate.latitude
            lng = localization.coordinate.longitude
        }
        delegate?.updateUserLocation(lat: lat , lng: lng )
    }
    
}
