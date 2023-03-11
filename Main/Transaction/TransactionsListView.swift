//
//  TransactionListView.swift
//  MoneyTraker
//
//  Created by Andrei Romanciuc on 14.02.2023.
//

import SwiftUI

struct TransactionsListView: View {
    
    let card: Card
    
    init(card: Card) {
        self.card = card
        
        fetchRequest = FetchRequest<CardTransaction>(entity: CardTransaction.entity(), sortDescriptors: [.init(key: "timestamp", ascending: false)], predicate: .init(format: "card == %@", self.card))
    }
    
    @State private var shouldShowTransactionForm = false
    
    @Environment(\.managedObjectContext) private var viewContext
    var fetchRequest: FetchRequest<CardTransaction>
    
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)],
//        animation: .default)
//    private var transactions: FetchedResults<CardTransaction>
    
    var body: some View {
        VStack{
            
            if fetchRequest.wrappedValue.isEmpty {
                Text("Get started by adding your first transaction")
            }
            
            Button {
                shouldShowTransactionForm.toggle()
            } label: {
                Text("+ Transaction")
                    .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                    .background(Color(.label))
                    .foregroundColor(Color(.systemBackground))
                    .font(.headline)
                    .cornerRadius(5)
            }
            .fullScreenCover(isPresented: $shouldShowTransactionForm) {
                AddTransactionForm(card: self.card)
            }
            
            ForEach(fetchRequest.wrappedValue) { transaction in
                CardTransactionView(transaction: transaction)
            }
        }
    }
}


struct CardTransactionView: View {
    
    
    let transaction: CardTransaction
    
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    @State var shouldPresentActionSheet = false
    
    
    private func deleteTransaction() {
        withAnimation {
            do {
                let context = PersistenceController.shared.container.viewContext
                context.delete(transaction)
                
                try context.save()
            } catch {
                print("Failed to delete transaction: \(error)")
            }
        }
    }
    
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.name ?? "")
                        .font(.headline)
                    
                    if let date = transaction.timestamp {
                        Text(dateFormatter.string(from: date))
                    }
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Button {
                        shouldPresentActionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                    }
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 0))
                    .confirmationDialog(transaction.name ?? "", isPresented: $shouldPresentActionSheet) {
                        
                        Button("Delete transaction", role: .destructive) {
                            deleteTransaction()
                        }
                        
                    } message: {
                        Text(transaction.name ?? "")
                    }
                    
                    
                    Text(String(format: "%.2f", transaction.amount))
                }
            }
            
            
            if let categories = transaction.categories as? Set<TransactionCategory> {
            
                let sortedByTimeStampCategories = Array(categories).sorted(by: {$0.timestamp?.compare($1.timestamp ?? Date()) == .orderedDescending})
                
                HStack {
                    ForEach(sortedByTimeStampCategories) { category in
                        HStack{
                            if let data = category.colorData, let uiColor = UIColor.color(data: data) {
                                let color = Color(uiColor)
                                Text(category.name ?? "")
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 8)
                                    .background(color)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            
                        }
                        
                    }
                    
                    Spacer()
                }
            }
            
            
            if let photoData = transaction.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
            
        }
        .foregroundColor(Color(.label))
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 5)
        .padding()
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static let firstcard: Card? = {
        let context = PersistenceController.shared.container.viewContext
        let request = Card.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        
        return try? context.fetch(request).first
    }()
    
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        ScrollView {
            
            if let card = firstcard {
                TransactionsListView(card: card)
            }
        }
        .environment(\.managedObjectContext, context)
    }
}
