import Foundation
import CoreGraphics

class Pawn: Piece {
    var justJumpedTwice: Bool = false
    override func isLegalMove(_ new_i: Int, _ new_j: Int, _ board: BoardViewModel) -> Bool {
        if self.team == "white" {
            // Move forward
            if new_i < self.i && new_j == self.j {
                if new_i + 1 == self.i && board[new_i, new_j] == nil {
                    return true
                } else if new_i + 2 == self.i && self.isFirstMove && board[new_i, new_j] == nil && board[new_i + 1, new_j] == nil {
                    return true
                }
            }
            // Capture move
            else if new_i + 1 == self.i && (new_j + 1 == self.j || new_j - 1 == self.j) && board[new_i, new_j]?.team == "black" {
                return true
            }
            // En passant
            else if self.i == 3 && new_i == 2 && (new_j + 1 == self.j || new_j - 1 == self.j) {
                if let opponentPawn = board[self.i, new_j] as? Pawn, opponentPawn.justJumpedTwice {
                    return true
                }
            }
        } else if self.team == "black" {
            // Move forward
            if new_i > self.i && new_j == self.j {
                if new_i - 1 == self.i && board[new_i, new_j] == nil {
                    return true
                } else if new_i - 2 == self.i && self.isFirstMove && board[new_i, new_j] == nil && board[new_i - 1, new_j] == nil {
                    return true
                }
            }
            // Capture move
            else if new_i - 1 == self.i && (new_j + 1 == self.j || new_j - 1 == self.j) && board[new_i, new_j]?.team == "white" {
                return true
            }
            // En passant
            else if self.i == 4 && new_i == 5 && (new_j + 1 == self.j || new_j - 1 == self.j) {
                if let opponentPawn = board[self.i, new_j] as? Pawn, opponentPawn.justJumpedTwice {
                    return true
                }
            }
        }
        return false
    }
    
    func fixPawnLogic(_ new_i: Int, _ new_j: Int, _ board: BoardViewModel) {
        // Handle first move
        if self.isFirstMove {
            if abs(new_i - self.i) == 2 {
                self.justJumpedTwice = true
            }
            self.isFirstMove = false
        }
        
        // Handle en passant capture
        if self.team == "white" && self.i == 3 && new_i == 2 {
            if let opponentPawn = board[self.i, new_j] as? Pawn, opponentPawn.justJumpedTwice {
                board[self.i, new_j] = nil  // Remove the opponent pawn
            }
        } else if self.team == "black" && self.i == 4 && new_i == 5 {
            if let opponentPawn = board[self.i, new_j] as? Pawn, opponentPawn.justJumpedTwice {
                board[self.i, new_j] = nil  // Remove the opponent pawn
            }
        }
    }
    
    func resetEnPassantFlag() {
        justJumpedTwice = false
    }
}
