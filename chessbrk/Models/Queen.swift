//
//  Queen.swift
//  chessbrk
//
//  Created by berke on 14.08.2024.
//

import Foundation

class Queen:Piece {
    //just combination of bishop and rook
    override func isLegalMove(_ new_i: Int, _ new_j: Int, _ board: BoardViewModel) -> Bool {
        var lineCount: Int = 0
        var linesToMove: Int = -1
        //move upwards or downwards
        
            if self.i != new_i && self.j == new_j {
                linesToMove = abs(new_i - self.i)
                let rowDirection = new_i > self.i ? 1 : -1
                
                for offset in 1...linesToMove {
                    let currentRow = self.i + offset * rowDirection
                    if board[currentRow, self.j]?.team == nil {
                        lineCount += 1
                    } else {
                        break
                    }
                }
                // If the path is clear and destination is not occupied
                if lineCount == linesToMove && board[new_i, self.j] == nil {
                    return true
                }
                //can eat black
                else if lineCount + 1 == linesToMove && board[new_i, self.j]?.team != self.team{
                    return true
                }
                
                
            }
            //move left or right
            
            else if  self.j != new_j && self.i == new_i{
                //                print("self.i = \(self.i), self.j = \(self.j) and new_i = \(new_i), new_j = \(new_j)")
                linesToMove = abs(new_j - self.j)
                let colDirection = new_j > self.j ? 1 : -1
                for offset in 1...linesToMove {
                    let currentCol = self.j + offset * colDirection
                    if board[self.i, currentCol]?.team == nil {
                        lineCount += 1
                    } else {
                        break
                    }
                }
                // If the path is clear and destination is not occupied
                if lineCount == linesToMove && board[self.i, new_j] == nil {
                    return true
                }
                //can eat black
                else if lineCount + 1 == linesToMove && board[self.i, new_j]?.team != self.team{
                    return true
                }
                
            }else{
                let diagonalDistance = abs(new_i - self.i)
                if diagonalDistance != abs(new_j - self.j) {
                    return false
                }// i+1, j-1 diagonally are equal
                
                // Determine direction of movement
                //new_i > self.i, moves upwards
                //new_j > self.j, moves right
                
                let rowDirection = new_i > self.i ? 1 : -1
                let colDirection = new_j > self.j ? 1 : -1
                
                if diagonalDistance < 1 {
                    return false
                }
                
                // Check all squares along the path
                for step in 1..<diagonalDistance {
                    let currentRow = self.i + step * rowDirection
                    let currentCol = self.j + step * colDirection
                    
                    // Ensure the currentRow and currentCol are within valid bounds before accessing the board
                    if currentRow < 0 || currentRow >= 8 || currentCol < 0 || currentCol >= 8 {
                        continue  // Skip invalid positions
                    }
                    
                    if board[currentRow, currentCol] != nil {
                        return false  // Path is blocked
                    }
                }
                
                // If the path is clear, check if the destination is occupied by an opponent piece or is empty
                if let destinationPiece = board[new_i, new_j] {
                    return destinationPiece.team != self.team  // Capture opponent piece
                } else {
                    return true  // Move to an empty square
                }
            }
        
        return false
    }
}
