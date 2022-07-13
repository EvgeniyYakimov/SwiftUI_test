//
//  ViewObject.swift
//  TestSwiftUI
//
//  Created by Евгений on 05.07.2022.
//

import SwiftUI
import UIKit
import MessageUI



struct ViewObject: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State var showEmailComposer = false
    @State var comment: String = ""
    @State var ObjFoto: FotoObject?
    @EnvironmentObject var vModel: ViewModel
    var editingObject: FotoModelObj?
    
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        
        
        NavigationView {
            
            VStack{
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 10) {
                        if let masOfImages = ObjFoto {
                            ForEach(masOfImages.image , id: \.self) { myImage in
                                VStack {
                                    Image(uiImage: myImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
                                }
                                
                            }
                        }
                    }
                }.padding(.horizontal)
                
                VStack {
                    Section {
                        //TextEditor(text: $comment )
                        TextField("", text: $comment )
                            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width - 20, minHeight: 50, maxHeight: 50)
                            .border(Color.blue)
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
                    
                    if let objectFt = editingObject {
                        shareCD.savePhotoObject(objModel: objectFt, comment: comment, images: ObjFoto!.image)
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                }  label: {
                    Text("Сохранить")
                        .font(.headline)
                        .padding()
                        .frame(height: 40)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button {
                    if let objectFt = editingObject {
                        shareCD.deletePhotoObject(objModel: objectFt)
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                }  label: {
                    Text("Удалить")
                        .font(.headline)
                        .padding()
                        .frame(height: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button("Отправить на почту") {
                    nameIsFocused = false
                    if MailView.canSendEmail() {
                        showEmailComposer = true
                    }    else {
                        
                        print("error")
                        // alertMessage = "Unable to send an email from this device."
                        //showAlert = true
                    }
                }
                
                
                .sheet(isPresented: $showEmailComposer, content: {
                    let dat = DataEmail(subject: ObjFoto?.comment ?? "", recipients: ["evgeniion@gmail.com"], images: ObjFoto?.image ?? [])
                    MailView(dataEmail: dat) { result in
                        print(result)
                    }
                })
                .sheet(isPresented: $vModel.showPicker) {
                    ImagePickerView(sourceType: vModel.source == .library ? .photoLibrary : .camera)  { image in
                        ObjFoto?.image.append(image)
                    }
                }
                Spacer()
            }
        } .navigationTitle("Детали")
        
    }
    
}


struct ViewObject_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}

