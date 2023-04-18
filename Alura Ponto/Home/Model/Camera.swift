//
//  Camera.swift
//  Alura Ponto
//
//  Created by Franklin Carvalho on 12/04/23.
//

import Foundation
import UIKit

protocol CamerDelegate: AnyObject{
    func didSelectPhoto(_ image: UIImage)
}

class Camera: NSObject {
    
    weak var delegate: CamerDelegate?
    
    func openCamera(_ controller: UIViewController, _ imagePicker: UIImagePickerController){
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.front) ?  .front : .rear
        controller.present(imagePicker, animated: true)
    }
}


// MARK: - Extensions

extension Camera: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let photo = info[.editedImage] as? UIImage else { return }
        
        delegate?.didSelectPhoto(photo)
    }
}
