//
//  Camera.swift
//  Alura Ponto
//
//  Created by Franklin Carvalho on 12/04/23.
//

import Foundation
import UIKit

class Camera: NSObject {
    
    func openCamera(_ controller: UIViewController, _ imagePicker: UIImagePickerController){
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        controller.present(imagePicker, animated: true)
    }
}
