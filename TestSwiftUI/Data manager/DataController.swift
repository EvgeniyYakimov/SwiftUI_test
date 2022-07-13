

import Foundation
import Combine
import CoreData
import SwiftUI

let shareCD  = DataController()

class DataController : ObservableObject {
    
    
    let container = NSPersistentContainer(name: "FotoModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func savePhotoObject(objModel: FotoModelObj?, comment: String, images: [UIImage]) {
        
        var newPhotoObject : FotoModelObj
        
        if let objModelPhoto = objModel {
            newPhotoObject = objModelPhoto
        } else {
            newPhotoObject = FotoModelObj(context: container.viewContext)
        }
        newPhotoObject.comment = comment
        
        var coreDataArray = [UIImage] ()
        var dataArray1 : Data?
        //
        for img in images {
            coreDataArray.append(img)
        }
        
        dataArray1 = coreDataObjectFromImages(images: coreDataArray)
        newPhotoObject.image = dataArray1
        
        do {
            try container.viewContext.save()
        } catch {
            print("Ошибка при сохранении \(error)")
        }
        
    }
    
    func deletePhotoObject(objModel: FotoModelObj) {
        container.viewContext.delete(objModel)
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print("Ошибка при удалении \(error)")
        }
    }
    
    
    private func coreDataObjectFromImages(images: [UIImage]) -> Data? {
        let dataArray = NSMutableArray()
        
        for img in images {
            if let data = img.pngData() {
                dataArray.add(data)
            }
        }
        
        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
    }
    
    
}



