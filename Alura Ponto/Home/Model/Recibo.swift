//
//  Camera.swift
//  Alura Ponto
//
//  Created by Franklin Carvalho on 12/04/23.
//


import Foundation
import UIKit
import CoreData

@objc(Recibo)
class Recibo: NSManagedObject {
    
    @NSManaged var id: UUID
    @NSManaged var status: Bool
    @NSManaged var data: Date
    @NSManaged var foto: UIImage
    
    convenience init(status: Bool, data: Date, foto: UIImage) {
        let contexto = UIApplication.shared.delegate as! AppDelegate
        self.init(context: contexto.persistentContainer.viewContext)
        self.id = UUID()
        self.status = status
        self.data = data
        self.foto = foto
    }
}

// MARK: - Extensions
extension Recibo{
    
    // MARK: - DAO
    func save(_ contexto: NSManagedObjectContext){
        do{
            try contexto.save()
        }catch{
            print (error.localizedDescription)
        }
    }
    
    func delete(_ contexto: NSManagedObjectContext){
        contexto.delete(self)
        do{
            try contexto.save()
        }catch{
            print (error.localizedDescription)
        }
    }
    
    class func fetchRequest() -> NSFetchRequest<Recibo> {
        return NSFetchRequest(entityName: "Recibo")
    }
    
   class func getDataPersist(_ fetchedResultController: NSFetchedResultsController<Recibo>){
        
        do{
            try fetchedResultController.performFetch()
        }catch{
            print (error.localizedDescription)
        }
    }
}


