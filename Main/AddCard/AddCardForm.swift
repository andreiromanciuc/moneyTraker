//
//  AddCardForm.swift
//  MoneyTraker
//
//  Created by Andrei Romanciuc on 31.01.2023.
//

import SwiftUI

struct AddCardForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var cardNumber = ""
    @State private var limit = ""
    
    @State private var cardType = "Visa"
    @State private var mounth = 1
    @State private var year = Calendar.current.component(.year, from: Date())
    
    @State private var color: Color = .blue
    
    private let currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View{
        NavigationView {
            Form {
                Section(header: Text("Card Info")){
                    TextField("Name", text: $name)
                    TextField("Credit card number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Credit Limit", text: $limit)
                        .keyboardType(.numberPad)
                    
                    Picker("Type", selection: $cardType) {
                        ForEach(["Visa", "Mastercard"], id: \.self) {
                            cardType in
                            Text(String(cardType)).tag(cardType)
                        }
                    }
                }
                
                Section(header: Text("Expiration")){
                    Picker("Mounth", selection: $mounth) {
                        ForEach(1..<13, id: \.self) {
                            mounth in
                            Text(String(mounth)).tag(String(mounth))
                        }
                    }
                    
                    Picker("Year", selection: $year) {
                        ForEach(currentYear..<currentYear + 20, id: \.self) {
                            mounth in
                            Text(String(mounth)).tag(String(mounth))
                        }
                    }
                }
                
                Section(header: Text("Color")){
                    ColorPicker("Color", selection: $color)
                }
                
            }
            .navigationTitle("Add card form")
            .navigationBarItems(leading: cancelButton, trailing: savebutton)
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
        })
    }
    
    private var savebutton: some View {
        Button(action: {
            let viewContext = PersistenceController.shared.container.viewContext
            
            let card = Card(context: viewContext)
            card.name = self.name
            card.number = self.cardNumber
            card.expMounth = Int16(self.mounth)
            card.expYear = Int16(self.year)
            card.limit = Int16(self.limit) ?? 0
            card.timestamp = Date()
            card.color = UIColor(self.color).encode()
            card.type = cardType
            
            do{
                try viewContext.save()
                
                presentationMode.wrappedValue.dismiss()
            } catch {
             print("Failed to persist new card: \(error)")
            }
            
        }, label: {
            Text("Save")
        })
    }
}

extension UIColor {
    
    class func color(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
    }
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
        AddCardForm()
    }
}
