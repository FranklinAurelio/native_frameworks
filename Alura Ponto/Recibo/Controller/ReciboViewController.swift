//
//  Camera.swift
//  Alura Ponto
//
//  Created by Franklin Carvalho on 12/04/23.
//

import UIKit
import CoreData

class ReciboViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var escolhaFotoView: UIView!
    @IBOutlet weak var reciboTableView: UITableView!
    @IBOutlet weak var fotoPerfilImageView: UIImageView!
    @IBOutlet weak var escolhaFotoButton: UIButton!
    
    // MARK: - Atributos
    
    private lazy var camera = Camera()
    private lazy var imageController = UIImagePickerController()
    
    
    var contexto: NSManagedObjectContext = {
        let contexto = UIApplication.shared.delegate as! AppDelegate
        return contexto.persistentContainer.viewContext
    }()
    
    let searching: NSFetchedResultsController<Recibo> = {
        
        let fetchRequest: NSFetchRequest<Recibo> = Recibo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "data", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let contexto = UIApplication.shared.delegate as! AppDelegate
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuraTableView()
        configuraViewFoto()
        searching.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRecibos()
        getImageProfile()
        reciboTableView.reloadData()
    }
    
    // MARK: - Class methods
    
    func getRecibos(){
        Recibo.getDataPersist(searching)
    }
    
    func getImageProfile() {
        if let imageProfile = Profile().loadImage(){
            fotoPerfilImageView.image = imageProfile
        }
    }
    
    func configuraViewFoto() {
        escolhaFotoView.layer.borderWidth = 1
        escolhaFotoView.layer.borderColor = UIColor.systemGray2.cgColor
        escolhaFotoView.layer.cornerRadius = escolhaFotoView.frame.width/2
        escolhaFotoButton.setTitle("", for: .normal)
    }
    
    func configuraTableView() {
        reciboTableView.dataSource = self
        reciboTableView.delegate = self
        reciboTableView.register(UINib(nibName: "ReciboTableViewCell", bundle: nil), forCellReuseIdentifier: "ReciboTableViewCell")
    }
    
    func showMenuGalery(){
        let menu = UIAlertController(title: "Seleção de foto", message: "Escolha uma foto da biblioteca", preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.camera.delegate = self
                self.camera.openPhotoLibrary(self, self.imageController)
            }
        }))
        
         menu.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        present(menu, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func escolherFotoButton(_ sender: UIButton) {
        showMenuGalery()
    }
}

extension ReciboViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReciboTableViewCell", for: indexPath) as? ReciboTableViewCell else {
            fatalError("erro ao criar ReciboTableViewCell")
        }
        
        let recibo = searching.fetchedObjects?[indexPath.row]
        cell.configuraCelula(recibo)
        cell.delegate = self
        cell.deletarButton.tag = indexPath.row
        
        return cell
    }
}

extension ReciboViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recibo = searching.fetchedObjects?[indexPath.row]
        let mapViewController = MapViewController.intanciar(recibo)
        mapViewController.modalPresentationStyle = .automatic
        
        present(mapViewController, animated: true)
    }
}

extension ReciboViewController: ReciboTableViewCellDelegate {
    func deletarRecibo(_ index: Int) {
       
        LocalAuthentication().authUser { isAuth in
            if isAuth {
                guard let recibo  = self.searching.fetchedObjects?[index] else{ return }
                recibo.delete(self.contexto)
            }
        }
        
       
        
        
        //reciboTableView.reloadData()
    }
}

extension ReciboViewController: CamerDelegate {
    func didSelectPhoto(_ image: UIImage) {
        Profile().saveImage(image)
        escolhaFotoButton.isHidden = true
        fotoPerfilImageView.image = image
    }
}

extension ReciboViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                reciboTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default:
            reciboTableView.reloadData()
        }
    }
}
