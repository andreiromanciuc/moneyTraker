//
//  MainView.swift
//  MoneyTraker
//
//  Created by Andrei Romanciuc on 31.01.2023.
//

import SwiftUI



struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if !cards.isEmpty {
                    TabView {
                        ForEach(cards) { card in
                            CardView(card: card)
                                .padding(.bottom, 50)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                } else {
                    emptyPromptMessage
                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm) {
                        AddCardForm()
                    }
            }
            .navigationTitle("Credit cards")
            .navigationBarItems(trailing: addCardButton)
        }
        
    }
    
    private var emptyPromptMessage: some View {
        VStack {
            Text("You currently have no cards in the system.")
                .padding(.horizontal, 48)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            
            Button {
                shouldPresentAddCardForm.toggle()
            } label: {
                Text("+ Add your first card")
                    .foregroundColor(Color(.systemBackground))
            }
            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
            .background(Color(.label))
            .cornerRadius(10)
            
        }.font(.system(size: 22, weight: .semibold))
    }
    
    struct CardView: View {
        
        let card: Card
        
        @State private var actionSheet = false
        @State private var shouldShowEditForm = false
        @State var refreshId = UUID()
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                
                HStack{
                    Text(card.name ?? "")
                        .font(.system(size: 24, weight: .semibold))
                    Spacer()
                    Button {
                        actionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .confirmationDialog(Text("Title"), isPresented: $actionSheet) {
                        
                        Button("Edit") {
                            shouldShowEditForm.toggle()
                        }
                        
                        Button("Delete card", role: .destructive) {
                            deleteCard()
                        }
                    } message: {
                        Text(self.card.name ?? "")
                    }
                    
                }
                
                
                HStack {
                    Image(card.type ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)
                    Spacer()
                    Text("Balance: 50000")
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text(card.number ?? "")
                
                HStack {
                    Text("Credit limit: \(card.limit)")
                    Spacer()
                    VStack{
                        Text("Valid Thru")
                        Text("\(card.expMounth)/\(card.expYear)")
                    }
                    
                }
                
            }
            .foregroundColor(.white)
            .padding()
            .background(
                
                VStack {
                    if let colorData = card.color,
                        let uiColor = UIColor.color(data: colorData),
                        let actualColor = Color(uiColor) {
                        LinearGradient(colors: [actualColor.opacity(0.5), actualColor], startPoint: .center, endPoint: .bottom)
                    } else {
                        Color.purple
                    }
      
                }
                
            )
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
            
            .fullScreenCover(isPresented: $shouldShowEditForm) {
                AddCardForm(card: self.card)
            }
        }
        
        private func deleteCard() {
            let viewContext = PersistenceController.shared.container.viewContext
            
            viewContext.delete(card)
            
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    
    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        MainView()
            .environment(\.managedObjectContext, viewContext)
    }
}
