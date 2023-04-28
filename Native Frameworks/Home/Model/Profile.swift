//
//  Profile.swift
//  Alura Ponto
//
//  Created by Franklin Carvalho on 25/04/23.
//

import Foundation
import UIKit

class Profile {
    
    private let imageName = "profile.png"
    
    func saveImage(_ image: UIImage){
        
        guard let dir  = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        
        let archiveUrl = dir.appendingPathComponent(imageName)
        
        if FileManager.default.fileExists(atPath: archiveUrl.path){
            removeOldImage(archiveUrl.path)
        }
        guard let imageData = image.jpegData(compressionQuality: 1) else {return}
        do{
            try imageData.write(to: archiveUrl)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    private func removeOldImage(_ url:String){
        do{
            try FileManager.default.removeItem(atPath: url)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func  loadImage() -> UIImage? {
        let dir  = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let archiveUrl = NSSearchPathForDirectoriesInDomains(dir, userDomainMask, true)
        
        if let path = archiveUrl.first{
            let imageUrl = URL(fileURLWithPath: path).appendingPathComponent(imageName)
            
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        
        return nil
        
    }
}
