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
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
            }))
        }
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
        AddCardForm()
    }
}
