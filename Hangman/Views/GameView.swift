import SwiftUI

struct GameView: View {
    @State private var selectedDifficulty: String
    @State private var palabraOculta: String = ""
    @State private var randomWord: String = ""
    @State private var isGameOver: Bool = false
    @State private var showCongratsMessage: Bool = false
    @State private var attempts: Int = 0
    @State private var fallos: Int = 0
    @State private var isButtonEnabled: [[Bool]] = Array(repeating: Array(repeating: true, count: 6), count: 4)

    init(selectedDifficulty: String) {
        self._selectedDifficulty = State(initialValue: selectedDifficulty)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Game")
                .font(.title)
                .bold()

            let abcArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "Ñ", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

            VStack {
                Text(palabraOculta)
                    .font(.system(size: 65))
                    .padding(.bottom, 30)

                Image("hangman\(fallos+1)")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaledToFit()

                // CREACION DE LOS BOTONES (TECLAS)
                ForEach(0..<4) { i in
                    HStack {
                        ForEach(0..<6) { j in
                            let index = j + (i * 6)
                            if index < abcArray.count {
                                let letra = abcArray[index]

                                Button(action: {
                                    if isButtonEnabled[i][j] && !isGameOver {
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
                                        isButtonEnabled[i][j] = false
                                    }
                                }) {
                                    Text(letra)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(.white))
                                        .padding()
                                        .background(Color(.lightGray))
                                        .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!isButtonEnabled[i][j])

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
                    // Puedes realizar acciones específicas cuando el juego termina
                }

                Text("INTENTOS: \(attempts)")
                    .font(.system(size: 24))
                    .padding(.top, 15)
            }
            .padding()
        }
        .onAppear {
            palabraOculta = generarPalabraOculta(selectedDifficulty, randomWord: &randomWord)
        }
    }
}

func generarPalabraOculta(_ selectedDifficulty: String, randomWord: inout String) -> String {
    var palabras: [String] = []

    switch selectedDifficulty {
    case "Fácil":
        palabras = ["sol", "pan", "luz", "mar", "uva", "rio", "oro", "ley", "voz", "sal"]
    case "Intermedia":
        palabras = ["casa", "dado", "nube", "pato", "vino", "moto", "azul", "rojo", "flor", "gris"]
    case "Difícil":
        palabras = ["valor", "libro", "cielo", "reloj", "tigre", "pilar", "verde", "yegua", "nieve", "casco"]
    default:
        return ""
    }

    guard let palabraRandom = palabras.randomElement() else {
        return ""
    }

    // Almacena la palabra aleatoria en randomWord
    randomWord = palabraRandom

    // Retorna la palabra oculta con guiones bajos y espacios
    return String(repeating: "_ ", count: palabraRandom.count - 1) + "_"
}

func letraEnPalabra(_ palabraRandom: String, _ letra: String) -> Bool {
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
    return nuevaPalabraOculta
}
