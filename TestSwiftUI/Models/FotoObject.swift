
import Foundation
import UIKit
import CoreData
 
struct FotoObject: Hashable {
   // let id: Int?
    var comment: String?
    var image: [UIImage] = []
    var im : UIImage?
   
    
    init(ModelObj: FotoModelObj) {
        self.comment = ModelObj.comment ?? ""
        self.image = imagesFromCoreData(object: ModelObj.image) ?? [UIImage()]
        
    }
    
    func imagesFromCoreData(object: Data?) -> [UIImage]? {
        var retVal = [UIImage]()

        guard let object = object else { return nil }
        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: object) {
            for data in dataArray {
                if let data = data as? Data, let image = UIImage(data: data) {
                    retVal.append(image)
                }
            }
        }
        
        return retVal
    }
   
}



