//
//  Camera.swift
//  Alura Ponto
//
//  Created by Franklin Carvalho on 12/04/23.
//

import UIKit
import CoreData
import CoreLocation

class HomeViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var horarioView: UIView!
    @IBOutlet weak var horarioLabel: UILabel!
    @IBOutlet weak var registrarButton: UIButton!

    // MARK: - Attributes
    
    private var timer: Timer?
    private lazy var camera = Camera()
    private lazy var imageController = UIImagePickerController()
    
    private var lat: CLLocationDegrees?
    private var lng: CLLocationDegrees?
    
    var contexto: NSManagedObjectContext = {
        let contexto = UIApplication.shared.delegate as! AppDelegate
        return contexto.persistentContainer.viewContext
    }()
    
    lazy var managerLocation = CLLocationManager()
    private lazy var localization = Localization()
    private lazy var reciboSrevice = ReciboSrevice()
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuraView()
        atualizaHorario()
        requestUserLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configuraTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    // MARK: - Class methods
    
    func configuraView() {
        configuraBotaoRegistrar()
        configuraHorarioView()
    }
    
    func configuraBotaoRegistrar() {
        registrarButton.layer.cornerRadius = 5
    }
    
    func configuraHorarioView() {
        horarioView.backgroundColor = .white
        horarioView.layer.borderWidth = 3
        horarioView.layer.borderColor = UIColor.systemGray.cgColor
        horarioView.layer.cornerRadius = horarioView.layer.frame.height/2
    }
    
    func configuraTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(atualizaHorario), userInfo: nil, repeats: true)
    }
    
    @objc func atualizaHorario() {
        let horarioAtual = FormatadorDeData().getHorario(Date())
        horarioLabel.text = horarioAtual
    }
    
    func tryOpoenCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            camera.delegate = self
            camera.openCamera(self, imageController)
        }
    }
    
    func requestUserLocation () {
        localization.delegate = self
        localization.getPermission(managerLocation)
    }
    
    // MARK: - IBActions
    
    @IBAction func registrarButton(_ sender: UIButton) {
        let recibo = Recibo(status: false, data: Date(), foto: UIImage(), lat: lat ?? 0.0, lng: lng ?? 0.0)
       
        
        reciboSrevice.post(recibo) { [weak self] isSave in
            if !isSave{
                guard let contexto = self?.contexto else {return}
                recibo.save(contexto)
            }
        }
        //tryOpoenCamera()
    }
}

// MARK: - Extensions

extension HomeViewController: CamerDelegate{
    func didSelectPhoto(_ image: UIImage) {
        /*let recibo = Recibo(status: false, data: Date(), foto: image, lat: lat ?? 0.0, lng: lng ?? 0.0)
        recibo.save(contexto)
        
        let reciboSrevice = ReciboSrevice()
        reciboSrevice.post(recibo)*/
    }
}

extension HomeViewController: LocalizationDelegate {
    func updateUserLocation(lat: Double?, lng: Double?) {
        self.lat = lat ?? 0.0
        self.lng = lng ?? 0.0
    }
}


