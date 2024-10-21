//
//  ContentView.swift
//  Project6_TranslationMe
//
//  Created by David Perez on 10/18/24.
//

import SwiftUI

struct ContentView: View {
    @State var nonTranslated = ""
    @State var translated = ""
    @State var historyTapped = false
    @StateObject var translationVM = TranslationVM()
    
    var colors = ["Spanish", "Hindi", "Mandarin", "Portuguese"]
    @State var selectedTranslationLanguage = "Hindi"
    
    var body: some View {
        
        VStack {
            Text("Translate Me")
                .font(.largeTitle)
                .fontWeight(.bold)
            TextField("Enter Text", text: $nonTranslated)
                .padding()
                .border(Color.orange, width: 5)
                .foregroundStyle(.black)
                .background(content: {
                    Color.white
                })
                
            HStack{
                Button(action: {
                    Task{
                        translated = await translationVM.getTranslation(translate: nonTranslated)
                    }
                }, label: {
                    Rectangle()
                        .frame(height: 75)
                        .clipShape(.buttonBorder)
                        .overlay(content: {
                            Text("Translate")
                                .foregroundStyle(.white)
                        })
                })
                
                Picker("Please choose a color", selection: $selectedTranslationLanguage) {
                    ForEach(colors, id: \.self) {
                        Text($0)
                    }
                }
                .tint(.white)
                .padding()
                .border(Color.orange)
                
            }
            VStack{
                Rectangle()
                    .foregroundStyle(.white)
                    .overlay(content: {
                        VStack{
                            Text("Translation:")
                            Text("\(translated)")
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .foregroundStyle(.black)
                    })
                Button(action: {
                    historyTapped = true
                }, label: {
                    Rectangle()
                        .frame(height: 35)
                        .overlay(content: {
                            Text("History")
                                .foregroundStyle(.white)
                            
                        })
                })
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .background(content: {
            Color(red: 0.1, green: 0.1, blue: 0.135)
                .ignoresSafeArea()
        })
        .foregroundColor(.orange)
        .sheet(isPresented: $historyTapped, content: {
            VStack{
                VStack{
                    ForEach(translationVM.savedTranslation) { savedTranslation in
                        Rectangle()
                            .foregroundStyle(Color.white)
                            .frame(height: 50)
                            .overlay(content: {
                                Text("\(savedTranslation.nonTranslated) -> \(savedTranslation.translated)")
                            })
                    }
                    Spacer()
                    Button(action: {
                        translationVM.savedTranslation = []
                    }, label: {
                        Rectangle()
                            .foregroundStyle(Color.red)
                            .frame(height: 50)
                            .overlay(content: {
                                Text("Delete all")
                                    .foregroundStyle(.white)
                            })
                    })
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(content: {
                Color(red: 0.9, green: 0.9, blue: 0.9)
            })
        })
        
    }
}

#Preview {
    ContentView()
}
