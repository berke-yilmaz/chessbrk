import SwiftUI

struct BeginView: View {
    let username: String
    @StateObject var viewModel: BeginViewModel = BeginViewModel()
    @State private var gameId = UUID() // Unique identifier for the game instance
    @State private var isActive = false // Control navigation link activation

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                let buttonWidth = screenWidth * 0.6
                let buttonHeight = screenHeight * 0.08

                VStack {
                    Spacer()

                    Text("Oyun modu seçin")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .multilineTextAlignment(.center)

                    VStack(spacing: 20) {
                        // Play against AI
                        Button(action: {
                            viewModel.selectGameMode(mode: "ai")
                            startGame()
                        }) {
                            Label("brk'ye karşı oyna", systemImage: "person.fill.questionmark")
                                .labelStyle(.titleAndIcon)
                                .frame(width: buttonWidth, height: buttonHeight)
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }

                        // Self Play
                        Button(action: {
                            viewModel.selectGameMode(mode: "self")
                            startGame()
                        }) {
                            Label("Oyun alanı", systemImage: "person.fill")
                                .labelStyle(.titleAndIcon)
                                .frame(width: buttonWidth, height: buttonHeight)
                                .background(Color.green.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }

                        // Play Online
                        Button(action: {
                            viewModel.selectGameMode(mode: "online")
                            startGame()
                        }) {
                            Label("Online Oyna", systemImage: "person.2.fill")
                                .labelStyle(.titleAndIcon)
                                .frame(width: buttonWidth, height: buttonHeight)
                                .background(Color.orange.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                    
                    .padding(.horizontal, 20)
                    Spacer()
                }
                .frame(width: screenWidth, height: screenHeight)
                .overlay(
                    VStack {
                        if !viewModel.gameMode.isEmpty {
                            NavigationLink(
                                destination: GameView(gameMode: viewModel.gameMode, gameId: gameId, onRestart: resetGame),
                                isActive: $isActive
                            ) {
                                Text("Oyunu başlat")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .padding()
                                    .frame(width: buttonWidth * 0.8)
                                    .background(Color.red.opacity(0.7))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                            }
                        }
                    }
                    .frame(width: screenWidth)
                    .padding(.bottom, 30),
                    alignment: .bottom
                )
            }
        }
    }

    private func startGame() {
        self.gameId = UUID() // Reset the game ID to force a new game instance
        self.isActive = false // Activate the NavigationLink
    }

    func resetGame() {
        self.isActive = true // Go back to BeginView
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.startGame() // Trigger game restart after slight delay
        }
        print("resetGame triggered")
    }
    
}

#Preview {
    BeginView(username: "ads", viewModel: BeginViewModel())
}


