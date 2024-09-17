//
//  Player1.swift
//  chessbrk
//
//  Created by berke on 19.08.2024.
//

import Foundation

class PlayerViewModel: ObservableObject , Identifiable{
    let id = UUID()
    @Published var piecesOnBoard: [Piece] = []
    @Published var totalPoints: Int = 0
    @Published var piecesCaptured: [Piece] = []
    @Published var hasMoves: Bool = true
    @Published var color: String
    @Published var myKing: King?  // Direct reference to the player's king
    
    
    init(board: BoardViewModel, color: String) {
        self.color = color
        self.updatePiecesOnBoard(from: board)
    }
        
    func updatePiecesOnBoard(from board: BoardViewModel) {
        self.piecesOnBoard.removeAll()
        self.totalPoints = 0
        
        for i in 0..<8 {
            for j in 0..<8 {
                if let piece = board[i, j], piece.team == self.color {
                    self.piecesOnBoard.append(piece)
                    self.totalPoints += piece.value
                    if let kingPiece = piece as? King {
                        self.myKing = kingPiece  // Assign the king reference
                    }
                }
            }
        }
    }
     
    func checkIfAnyMoveIsPossible(board: BoardViewModel) {
        self.hasMoves = false
        for piece in piecesOnBoard {
            let myMoves = piece.legalMoves(board: board)
            if !myMoves.isEmpty {
                self.hasMoves = true
                break
            }
        }
    }
    
    func capturePiece(_ piece: Piece) {
        self.piecesCaptured.append(piece)
        self.removePiece(piece) // Ensure the piece is removed from the board before adjusting points
    }
    private func removePiece(_ piece: Piece) {
        if let index = piecesOnBoard.firstIndex(where: { $0 === piece }) {
            self.piecesOnBoard.remove(at: index)
            self.totalPoints -= piece.value
        }
    }    
}
