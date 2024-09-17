//
//  King.swift
//  chessbrk
//
//  Created by berke on 14.08.2024.
//

import Foundation

class King:Piece  {
    var isNextMoveBeingAttacked: Bool = false
    var hasMoved: Bool = false

    //Given location to castle this should work
    func castle(to newX: Int, newY: Int, board: BoardViewModel) {
        let rookNewY = newY == 6 ? 5 : 3  // Kingside or Queenside
        let rookOldY = newY == 6 ? 7 : 0  // White or Black

        // Move king
        board[i, j] = nil
        board[i, newY] = self
        
        self.j = newY
        self.currentX = CGFloat(newY)  // Adjusted to reflect correct coordinates
        self.currentY = CGFloat(newX)  // Adjusted to reflect correct coordinates
        
        // Move rook
        if let rook = board.getPiece(atRow: i, column: rookOldY) as? Rook {
            board[i, rookOldY] = nil
            board[i, rookNewY] = rook
            rook.j = rookNewY
            rook.currentX = CGFloat(rookNewY) // Adjusted to reflect correct coordinates
            rook.currentY = CGFloat(newX) // Adjusted to reflect correct coordinates
            
        }
       
        // Update hasMoved flags
        hasMoved = true
        (board[i, rookNewY] as? Rook)?.hasMoved = true
    }

    override func isLegalMove(_ new_i: Int, _ new_j: Int, _ board: BoardViewModel) -> Bool {
        // First, check if it's a regular king move
        if abs(self.i - new_i) <= 1 && abs(self.j - new_j) <= 1 {
            // Ensure the kings are not adjacent after the move
            if let opponentKing = board.findKing(for: self.team == "white" ? "black" : "white") {
                if abs(opponentKing.i - new_i) <= 1 && abs(opponentKing.j - new_j) <= 1 {
                    return false
                }
            }

            // Check if the destination is safe from checks
            if board.isPositionUnderAttack(i: new_i, j: new_j, team: self.team) {
                return false
            }

            // Ensure the move is either to an empty space or captures an opponent's piece
            if let destinationPiece = board[new_i, new_j] {
                return destinationPiece.team != self.team
            }
            return true
        }

        // Now handle castling
        if canCastle(to: new_i, new_j: new_j, board: board) {
            return true
        }

        return false
    }

     func canCastle(to new_i: Int, new_j: Int, board: BoardViewModel) -> Bool {
        // Castling conditions:
        // 1. King and Rook have not moved
        // 2. No pieces between them
        // 3. The squares the king passes through are not under attack
        // 4. King is not under attack
        if self.hasMoved {
            return false
        }
         if board.isKingInCheck{
             return false
         }

        // Check if castling is attempted to the correct row and two columns left or right
        if self.i == new_i && (abs(self.j - new_j) == 2) {
            let direction = (new_j - self.j) > 0 ? 1 : -1
            let rookColumn = direction == 1 ? 7 : 0  // Assuming rook is on the first or last column
            let rook = board[self.i, rookColumn] as? Rook
            
            if rook == nil || rook!.hasMoved {
                return false
            }

            // Check no pieces in between and not under attack
            let stepCount = abs(self.j - new_j)
            for step in 1..<stepCount {
                let betweenColumn = self.j + step * direction
                if board[self.i, betweenColumn] != nil || board.isPositionUnderAttack(i: self.i, j: betweenColumn, team: self.team) {
                    return false
                }
            }

            // Check if the final square is under attack
            if board.isPositionUnderAttack(i: self.i, j: new_j, team: self.team) {
                return false
            }

            return true
        }
        
        return false
    }

    
    
}
