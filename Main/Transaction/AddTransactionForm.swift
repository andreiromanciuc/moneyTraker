//
//  AddTransactionForm.swift
//  MoneyTraker
//
//  Created by Andrei Romanciuc on 05.02.2023.
//

import SwiftUI

struct AddTransactionForm: View {
    
    let card: Card
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var photoData: Data?
    
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
    
    private var saveButton: some View {
        Button {
            let context = PersistenceController.shared.container.viewContext
            let transaction = CardTransaction(context: context)
            transaction.name = self.name
            transaction.amount = Float(self.amount) ?? 0
            transaction.timestamp = self.date
            transaction.photoData = self.photoData
            transaction.card = self.card
            
            do {
                try context.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
              print("Failed to save transaction \(error)")
            }
            
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
    static let firstcard: Card? = {
        let context = PersistenceController.shared.container.viewContext
        let request = Card.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        
        return try? context.fetch(request).first
    }()
    
    
    static var previews: some View {
        if let card = firstcard {
            AddTransactionForm(card: card)
        }
    }
}
