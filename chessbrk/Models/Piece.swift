import SwiftUI
import Foundation

class Piece: Identifiable, ObservableObject, Equatable {
    let id = UUID()
    var i: Int
    var j: Int
    let value: Int
    var isFirstMove: Bool = true
    var team: String
    var currentX: CGFloat
    var currentY: CGFloat


    init(_ i: Int, _ j: Int, _ team: String, _ value: Int) {
        self.i = i
        self.j = j
        self.team = team
        // Calculate initial positions
        self.currentX = CGFloat(j)
        self.currentY = CGFloat(i)
        self.value = value
    }
    
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        return lhs.id == rhs.id
    }
    
    func isLegalMove(_ new_i: Int, _ new_j: Int, _ board: BoardViewModel) -> Bool {
        return false // Override in subclasses
    }
    
    func legalMoves(board: BoardViewModel) -> [(Int, Int)]{
        
        var possibleMoves: [(Int, Int)] = []
        for i in 0..<8 {
            for j in 0..<8 {
                
                if isLegalMove(i, j, board) {
                    if board.isKingInCheck{
                        if canProtectKingWithThisMove(i, j, board){
                            possibleMoves.append((i,j))
                        }
                    }else if !doesMyMoveEndInACheckForMyKing(i, j, board){
                        possibleMoves.append((i,j))
                    }
                }
            }
        }
        return possibleMoves
    }
    
    func canProtectKingWithThisMove(_ new_i: Int, _ new_j: Int, _ board: BoardViewModel) -> Bool {
        let originalPiece = board[self.i, self.j]
        let targetPiece = board[new_i, new_j]

        // Simulate the move
        board[self.i, self.j] = nil
        board[new_i, new_j] = self

        // Check king's safety after the move
        board.checkKingSafety()
        let canProtect = !board.isKingInCheck

        // Restore the board state
        board[self.i, self.j] = originalPiece
        board[new_i, new_j] = targetPiece

        // Reset the king's check status correctly by checking again
        board.checkKingSafety()

        return canProtect
    }

    
    func doesMyMoveEndInACheckForMyKing(_ new_i: Int, _ new_j: Int, _ board: BoardViewModel) -> Bool{
        return !canProtectKingWithThisMove(new_i,new_j,board)
    }
}
