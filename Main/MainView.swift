//
//  MainView.swift
//  MoneyTraker
//
//  Created by Andrei Romanciuc on 31.01.2023.
//

import SwiftUI



struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                TabView {
                    ForEach(0..<5) { num in
                        CardView()
                            .padding(.bottom, 50)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 280)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm) {
                        AddCardForm()
                    }
            }
            .navigationTitle("Credit cards")
            .navigationBarItems(trailing: addCardButton)
        }
    }
    
    struct CardView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Preview of our code so far")
                    .font(.system(size: 24, weight: .semibold))
                
                HStack {
                    Image("VisaImage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)
                    Spacer()
                    Text("Balance: $5,000")
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text("1234 1234 1234 1234")
                
                Text("Credit limit: $50,000")
                
                
                HStack { Spacer() }
                
            }
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(colors: [Color.blue.opacity(0.5), Color.blue], startPoint: .center, endPoint: .bottom)
            )
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
            
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
        MainView()
    }
}
