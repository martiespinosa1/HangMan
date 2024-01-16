//
//  Game.swift
//  Hangman
//
//  Created by Martí Espinosa Farran on 14/1/24.
//

import SwiftUI

struct GameView: View {
    @State private var selectedDifficulty: String
    @State private var showCongratsMessage: Bool = false
    @State private var hasWon: Bool = false
    
    init(selectedDifficulty: String) {
        self._selectedDifficulty = State(initialValue: selectedDifficulty)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Game")
                .font(.title)
                .bold()

            let abcArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "Ñ", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

            let palabras3Letras = ["sol", "pan", "luz", "mar", "uva", "rio", "oro", "ley", "voz", "sal"]
            let palabras4Letras = ["casa", "dado", "nube", "pato", "vino", "moto", "azul", "rojo", "flor", "gris"]
            let palabras5Letras = ["valor", "libro", "cielo", "reloj", "tigre", "pilar", "verde", "yegua", "nieve", "casco"]

            var randomWord = ""
            var palabraOculta = generarPalabraOculta(selectedDifficulty)
            let random = Int.random(in: 0..<10)
            var attempts = 0
            var fallos = 0

            Image(systemName: "photo")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(palabraOculta)
                    .font(.system(size: 65))
                    .padding(.bottom, 30)

                Image(systemName: "hangman\(fallos)")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaledToFit()

                let buttonColor = Color(.sRGB, red: 0.15, green: 0.15, blue: 0.15, opacity: 1.0)
                
                // CREACION DE LOS BOTONES (TECLAS)
                var isGameOver = false
                var showCongratsMessage = false

                ForEach(0..<4) { i in
                    HStack {
                        ForEach(0..<6) { j in
                            let index = j + (i * 6)
                            if index < abcArray.count {
                                let letra = abcArray[index]
                                @State var isButtonEnabled = true

                                Button(action: {
                                    if isButtonEnabled && !isGameOver {
                                        attempts += 1
                                        let letraEnPalabra = letraEnPalabra(randomWord, letra)
                                        if letraEnPalabra {
                                            palabraOculta = ponerLetras(randomWord, palabraOculta, letra)
                                            if !palabraOculta.contains("_") {
                                                // El jugador ha adivinado la palabra
                                                isGameOver = true
                                                showCongratsMessage = true
                                            }
                                        } else {
                                            fallos += 1
                                            if fallos == 9 {
                                                isGameOver = true
                                            }
                                        }

                                        // Deshabilitar el botón después de hacer clic
                                        isButtonEnabled = false
                                    }
                                }) {
                                    Text(letra)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(.lightGray))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!isButtonEnabled)

                                if j < 5 {
                                    Spacer(minLength: 12)
                                }
                            }
                        }
                    }
                    .padding(5)
                }

                // Fin de partida
                if isGameOver {
                    
                }
            


                Text("INTENTOS: \(attempts)")
                    .font(.system(size: 24))
                    .padding(.top, 15)
            }
            .padding()
        }
    }
}

func generarPalabraOculta(_ selectedDifficulty: String) -> String {
    switch selectedDifficulty {
    case "FÁCIL":
        return "_ _ _"
    case "NORMAL":
        return "_ _ _ _"
    case "DIFÍCIL":
        return "_ _ _ _ _"
    default:
        return ""
    }
}

func letraEnPalabra(_ palabraRandom: String, _ letra: String) -> Bool {
    print(palabraRandom)
    print(letra)
    print(palabraRandom.contains(letra.lowercased()))
    return palabraRandom.contains(letra.lowercased())
}

func ponerLetras(_ palabra: String, _ palabraOculta: String, _ letra: String) -> String {
    var nuevaPalabraOculta = ""
    for (i, char) in palabra.enumerated() {
        if char.lowercased() == letra.lowercased() {
            nuevaPalabraOculta += letra
        } else {
            let index = palabraOculta.index(palabraOculta.startIndex, offsetBy: i * 2)
            nuevaPalabraOculta += String(palabraOculta[index])
        }
    }
    print("palabra: \(palabra)")
    print("letra: \(letra)")
    print("palabraOculta actualizada: \(nuevaPalabraOculta)")
    return nuevaPalabraOculta
}
