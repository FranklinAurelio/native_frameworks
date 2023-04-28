//
//  MapViewController.swift
//  Alura Ponto
//
//  Created by Franklin Carvalho on 25/04/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var map: MKMapView!
    
    // MARK: - Atributes
    private var recibo: Recibo?
    
    // MARK: - Instance
    class func intanciar(_ recibo: Recibo?) -> MapViewController{
        let Controller = MapViewController(nibName: "MapViewController", bundle: nil)
        Controller.recibo = recibo
        return Controller
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setRegion()
        addMarker()
    }
    
    // MARK: - Methodos
    
    func setRegion(){
        
        guard let lat = recibo?.lat, let lng = recibo?.lng else{return}
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng), span: span)
        
        map.setRegion(region, animated: true)
    }
    
    func addMarker(){
        
        let annotation = MKPointAnnotation()
        annotation.title = "Registro de ponto"
        
        annotation.coordinate.latitude = recibo?.lat ?? 0.0
        annotation.coordinate.longitude = recibo?.lng ?? 0.0
        
        map.addAnnotation(annotation)
        
        //forma de pegar a localização atravez de um endereço
        /*let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString("Av. Paulista") { locations, error in
            let location = locations?.first
            
            let latitude  = location?.location?.coordinate.latitude
            let longitude  = location?.location?.coordinate.longitude
        }*/
    }
}
