//
//  Rook.swift
//  chessbrk
//
//  Created by berke on 14.08.2024.
//

import Foundation
import SwiftUI

class Rook: Piece {
    
    var hasMoved: Bool = false
    
    override func isLegalMove(_ new_i: Int, _ new_j: Int, _ board: BoardViewModel) -> Bool {
        var lineCount: Int = 0
        var linesToMove: Int = -1
        //move upwards or downwards
        

        if self.i != new_i && self.j == new_j {
//            print("self.i = \(self.i), self.j = \(self.j) and new_i = \(new_i), new_j = \(new_j)")
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
                
            }
        
    return false
    }
}
