//
//  ViewModel.swift

//
//  Created by Евгений on 29.06.2022.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var image: UIImage? {
        didSet {
            addMyImage(image: image!)
        }
    }
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
    @Published var myImages: [UIImage] = []
    @Published var selectedImage: MyImage?
    @Published var ObFoto: FotoObject?
    
    
    func showPhotoPicker() {
        if source == .camera {
            if !Picker.checkPermissions() {
                print("There is no camera on this device")
                return
            }
        }
        showPicker = true
    }
    

    func clear() {
        showPicker = false
        myImages = []
        source = .library
    }
    
    func addMyImage(image: UIImage) {
        let resizeImage = image.resizeImageTo(size: CGSize(width: 150, height: 150))
        myImages.append(resizeImage!)
        ObFoto?.image.append(resizeImage!)
    }
    
    
}
