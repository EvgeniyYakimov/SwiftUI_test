//
//  AddNewObject.swift
//  
//
//  Created by Евгений on 26.06.2022.
//

import SwiftUI
import UIKit



//@available(iOS 15.0, *)
struct AddNewObject: View {
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var nameIsFocused: Bool
    
    
    @State var comment: String = ""
    @EnvironmentObject var vModel: ViewModel
    @State var ObjFoto: FotoObject?
    
    var body: some View {
        
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 10) {
                        
                        ForEach(vModel.myImages , id: \.self) { myImg in
                            VStack {
                                Image(uiImage: myImg)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
                            }
                            
                        }
                    }
                }.padding(.horizontal)
                
                VStack {
                    Section {
                        //TextEditor(text: $comment )
                        TextField("Введите комментарий", text: $comment )
                            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width - 20, minHeight: 50, maxHeight: 50)
                            .border(Color.blue)
                            .submitLabel(.done)
                            .focused($nameIsFocused)
              
                    } header: {
                        Text("Введите комментарий").font(.headline)
                    }
                }
                .toolbar {
                     ToolbarItem(placement: .keyboard) {
                         Button("Done") {
                             nameIsFocused = false
                         }
                     }
                 }
                
                VStack {
                    HStack {
                        Button {
                            vModel.source = .camera
                            vModel.showPhotoPicker()
                            nameIsFocused = false
                        } label: {
                            Text("Камера")
                                .font(.headline)
                                .padding()
                                .frame(height: 40)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button {
                            vModel.source = .library
                            vModel.showPhotoPicker()
                            nameIsFocused = false
                            
                        }  label: {
                            Text("Фото")
                                .font(.headline)
                                .padding()
                                .frame(height: 40)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                    }
                    Button {
                        
                        if (!comment.isEmpty) || (!vModel.myImages.isEmpty) {
                          shareCD.savePhotoObject(objModel: nil, comment: comment, images: vModel.myImages)
                          vModel.clear()
                          presentationMode.wrappedValue.dismiss()
                        } else {
                            print("Данные для соранения не заполнены")
                        }
                        
                    }  label: {
                        Text("Сохранить")
                            .font(.headline)
                            .padding()
                            .frame(height: 40)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
                
                .sheet(isPresented: $vModel.showPicker) {
                    ImagePickerView(sourceType: vModel.source == .library ? .photoLibrary : .camera)  { image in
                        vModel.image = image
                    }
                }
                Spacer()
            }
        
        } .navigationTitle("Новый объект")
    }
}


struct AddNewObject_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
        
    }
}
