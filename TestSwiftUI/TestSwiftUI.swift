
import SwiftUI
import CoreData

@main
struct TestSwiftUI: App {
    @StateObject private var dataController =  shareCD
    @StateObject var vModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(vModel)
                .onAppear {
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
