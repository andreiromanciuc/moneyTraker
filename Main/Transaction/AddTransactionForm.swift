//
//  AddTransactionForm.swift
//  MoneyTraker
//
//  Created by Andrei Romanciuc on 05.02.2023.
//

import SwiftUI

struct AddTransactionForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    
    @State private var shouldPresentPhotoPicker = false
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Information")) {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    NavigationLink {
                        Text("new cat page")
                    } label: {
                        Text("Many to many")
                    }
                    
                }
                
                Section(header: Text("Photo/Receipt")) {
                    Button {
                        shouldPresentPhotoPicker.toggle()
                    } label: {
                        Text("Select Photo")
                    }
                    .fullScreenCover(isPresented: $shouldPresentPhotoPicker) {
                        PhotoPickerView(photoData: $photoData)
                    }
                    
                    if let data = self.photoData, let image = UIImage.init(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    }
                    
                }
                
            }
            .navigationTitle("Add transaction")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
    
    @State private var photoData: Data?
    
    
    
    private var saveButton: some View {
        Button {
            
        } label: {
            Text("Save")
        }
    }
    
    private var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
    }
    
}

struct AddTransactionForm_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionForm()
    }
}
