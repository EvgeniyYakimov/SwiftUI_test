//
//  ContentView.swift
//  TestSwiftUI
//
// 
//

import SwiftUI
import Combine
import CoreData

struct ContentView: View {
    
    @State var gridLayout: [GridItem] = [ GridItem() ]
    @State private var showBtnNewObject = false
    
    @Environment(\.managedObjectContext)  var viewContext
    @FetchRequest(sortDescriptors: []) var FotoObjs: FetchedResults<FotoModelObj>
    @EnvironmentObject var vModel: ViewModel
    
    
    var imgs : [UIImage?] = []
    var body: some View {
        
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .leading , spacing: 10) {
                    
                    ForEach(FotoObjs) { obj in
                        let obj1 = FotoObject(ModelObj: obj)
                        
                        NavigationLink (destination: ViewObject( comment: obj1.comment ?? "", ObjFoto: obj1, editingObject: obj)) {
                            
                            HStack {
                                ForEach(obj1.image, id: \.self) { img in
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
                                }
                                
                                Text(obj1.comment ?? "pusto")
                                    .foregroundColor(.black)
                                    .lineLimit(3)
                                    .frame(minWidth: 0,  maxWidth: .infinity,minHeight: 40, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                
                            }
                        }
                    }
                    
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.gray, lineWidth: 0.2))
                    .animation(.interactiveSpring(), value: gridLayout.count)
                }
            }
            
            .navigationTitle("Объекты")
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Новый") {
                        showBtnNewObject.toggle()
                        vModel.clear()
                    }
                    
                    .sheet(isPresented: $showBtnNewObject) {
                        AddNewObject()
                    }
                
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.gridLayout = Array(repeating: .init(.flexible()), count: self.gridLayout.count % 2 + 1)
                    }) {
                        Image(systemName: "square.grid.2x2")
                            .foregroundColor(.primary)
                    }
                }
                
            }
            
        }
        
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}

