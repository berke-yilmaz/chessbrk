import SwiftUI

struct BoardView: View {
    @ObservedObject var board: BoardViewModel
    @ObservedObject var player1: PlayerViewModel
    @ObservedObject var player2: PlayerViewModel
    
    @State private var showPromotionDialog = false
    @State private var pieceToPromote: Piece?
    @State private var highlightedMoves: [(i: Int, j: Int)] = []
    @State private var selectedPiece: Piece? = nil
    @State private var possibleMoves: [(Int, Int)] = []

    var body: some View {
        GeometryReader { geometry in
            let boardSize = min(geometry.size.width, geometry.size.height)
            let tileSize = boardSize / 8
            let boardOriginX = (geometry.size.width - boardSize) / 2
            let boardOriginY = (geometry.size.height - boardSize) / 2

            ZStack {
                Image("board")
                    .resizable()
                    .frame(width: boardSize, height: boardSize)
                    .padding()
                    .rotationEffect(.degrees(180))
                    .zIndex(1)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                if let lastMove = board.moveHistory.last {
                    Rectangle()
                        .fill(Color.yellow.opacity(0.3))
                        .frame(width: tileSize, height: tileSize)
                        .position(x: boardOriginX + CGFloat(lastMove.startY) * tileSize + tileSize / 2, y: boardOriginY + CGFloat(lastMove.startX) * tileSize + tileSize / 2)
                        .zIndex(1.5)

                    Rectangle()
                        .fill(Color.yellow.opacity(0.3))
                        .frame(width: tileSize, height: tileSize)
                        .position(x: boardOriginX + CGFloat(lastMove.endY) * tileSize + tileSize / 2, y: boardOriginY + CGFloat(lastMove.endX) * tileSize + tileSize / 2)
                        .zIndex(1.5)
                }
                
                ForEach(highlightedMoves.indices, id: \.self) { index in
                    let move = highlightedMoves[index]
                    Circle()
                        .fill(Color.green.opacity(0.5))
                        .frame(width: tileSize / 2, height: tileSize / 2)
                        .position(x: boardOriginX + CGFloat(move.j) * tileSize + tileSize / 2, y: boardOriginY + CGFloat(move.i) * tileSize + tileSize / 2)
                        .zIndex(1.5)
                        .onTapGesture {
                            if let piece = selectedPiece {
                                if let pawn = piece as? Pawn, (move.i == 0 || move.i == 7) {
                                    pieceToPromote = pawn
                                    showPromotionDialog = true
                                } else {
                                    board.movePiece(piece: piece, to: move.i, to: move.j, player1: player1, player2: player2)
                                    selectedPiece = nil
                                    highlightedMoves.removeAll()
                                }
                            }
                        }
                }
                
                ForEach(0..<8, id: \.self) { i in
                    ForEach(0..<8, id: \.self) { j in
                        if let piece = board.getPiece(atRow: i, column: j) {
                            PieceView(piece: piece, isSelected: piece == selectedPiece)
                                .frame(width: tileSize, height: tileSize)
                                .position(x: boardOriginX + CGFloat(j) * tileSize + tileSize / 2, y: boardOriginY + CGFloat(i) * tileSize + tileSize / 2)
                                .zIndex(2.0)
                                .onTapGesture {
                                    if highlightedMoves.contains(where: { $0.i == i && $0.j == j }) {
                                        if let piece = selectedPiece {
                                            if let pawn = piece as? Pawn, (i == 0 || i == 7) {
                                                board.movePiece(piece: piece, to: i, to: j, player1: player1, player2: player2)
                                                pieceToPromote = pawn
                                                showPromotionDialog = true
                                            } else {
                                                board.movePiece(piece: piece, to: i, to: j, player1: player1, player2: player2)
                                                selectedPiece = nil
                                                highlightedMoves.removeAll()
                                            }
                                        }
                                    } else {
                                        if piece.team == board.turn {
                                            selectedPiece = piece
                                            possibleMoves = piece.legalMoves(board: board)
                                            highlightedMoves = possibleMoves
                                        }
                                    }
                                }
                        }
                    }
                }
            }
            .sheet(isPresented: $showPromotionDialog) {
                if let pawn = pieceToPromote {
                    PromotionView(selectedPiece: $pieceToPromote, isPresented: $showPromotionDialog, team: pawn.team, i: pawn.i, j: pawn.j)
                        .onDisappear {
                            if let promotedPiece = pieceToPromote {
                                promotedPiece.i = pawn.i
                                promotedPiece.j = pawn.j
                                promotedPiece.currentX = pawn.currentX
                                promotedPiece.currentY = pawn.currentY
                                board.setPiece(promotedPiece)
                                selectedPiece = nil
                                highlightedMoves.removeAll()
                            }
                        }
                }
            }
        }.onAppear(){
            SoundManager.playSystemSound(named: "game-start")
        }
    }
}

#Preview {
    let board: BoardViewModel = BoardViewModel()
    return BoardView(board: board, player1: PlayerViewModel(board: board, color: "white"), player2: PlayerViewModel(board: board, color: "black"))
}
