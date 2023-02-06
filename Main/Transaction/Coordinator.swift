//
//  Coordinator.swift
//  MoneyTraker
//
//  Created by Andrei Romanciuc on 06.02.2023.
//

import Foundation
import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    private let parent: PhotoPickerView
    
    init(parent: PhotoPickerView) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        let imageData = image?.jpegData(compressionQuality: 1)
        self.parent.photoData = imageData
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
