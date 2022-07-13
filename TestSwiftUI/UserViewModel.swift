//
//  UserViewModel.swift
//  InfinitListSwiftUI
//
//  Created by Hafiz on 28/06/2021.
//

import Foundation
import Combine
import SwiftUI

class UserViewModel: ObservableObject {
    //@Published var fotoObjects: [FotoObj] = []
    @Environment(\.managedObjectContext)  var viewContext
    @Published var isRequestFailed = false
    private let pageLimit = 25
    private var currentLastId: Int? = nil
    private var cancellable: AnyCancellable?
    var fotoObjects: [FotoObject] = []
    
    func getUsers() {
        
        CoreDataManager.shared.fetchData { ft in
            self.fotoObjects = ft
        }
        
       /* cancellable = APIService.shared.fetchData(perPage: pageLimit, sinceId: currentLastId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.isRequestFailed = true
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { users in
                self.users.append(contentsOf: users)
                self.currentLastId = users.last?.id
            }
*/
    }
}
