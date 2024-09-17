
import SwiftUI

struct GameView: View {
    @StateObject var myBoard: BoardViewModel
    @StateObject var player1: PlayerViewModel
    @StateObject var player2: PlayerViewModel
    @State var gameMode: String
    @State private var showGameOverView: Bool = true
    var gameId: UUID // Receive the gameId
    var onRestart: () -> Void // Callback to reset the game
    
    init(gameMode: String, gameId: UUID, onRestart: @escaping () -> Void) {
        let board = BoardViewModel()
        self._myBoard = StateObject(wrappedValue: board)
        self._player1 = StateObject(wrappedValue: PlayerViewModel(board: board, color: "white"))
        self._player2 = StateObject(wrappedValue: PlayerViewModel(board: board, color: "black"))
        self.gameMode = gameMode
        self.gameId = gameId
        self.onRestart = onRestart
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            VStack(spacing: 0) {
                ScoreDifferenceBarView(player1: player1, player2: player2)
                    .frame(width: screenWidth, height: screenHeight * 0.1)
                BoardView(board: myBoard, player1: player1, player2: player2)
                    .frame(width: screenWidth, height: screenHeight * 0.8)
            }
            .navigationBarBackButtonHidden(true) // Hide the back button
            .overlay(
                VStack {
                    if myBoard.gameMessage != "continue" {
                        if showGameOverView {
                            GameOverView(gameMessage: myBoard.gameMessage, onRestart: onRestart, isPresented: $showGameOverView)
                        }
                    }
                    
                    Text("Game Mode: \(gameMode.capitalized)")
                        .font(.title2)
                        .padding(.top, 10)
                        .cornerRadius(8)
                        .padding(.top, 8)
                }
                .frame(width: screenWidth),
                alignment: .bottom
            )
        }
    }
    
}

#Preview {
    GameView(gameMode: "self", gameId: UUID(), onRestart: {
        print("game")
    })
}
