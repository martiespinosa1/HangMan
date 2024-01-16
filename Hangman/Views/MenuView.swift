//
//  ContentView.swift
//  Hangman
//
//  Created by Martí Espinosa Farran on 13/1/24.
//

import SwiftUI

struct MenuView: View {
    @State private var selectedDifficulty: String = "Intermedia"
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Menu")
                    .font(.title)
                    .bold()

                Image("hangman")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                
                Menu("Dificultad: \(selectedDifficulty)") {
                    Button("Fácil") {
                        selectedDifficulty = "Fácil"
                    }
                    Button("Intermedia") {
                        selectedDifficulty = "Intermedia"
                    }
                    Button("Difícil") {
                        selectedDifficulty = "Difícil"
                    }
                }
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                
                NavigationLink(
                    destination: GameView(selectedDifficulty: selectedDifficulty),
                    label: {
                        Text("Jugar")
                    }
                )
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                
                Button("Ayuda", action: {
                    print("Ayuda")
                })
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
            }
            .padding()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
