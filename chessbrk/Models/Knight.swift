//
//  Knight.swift
//  chessbrk
//
//  Created by berke on 14.08.2024.
//

import Foundation

class Knight:Piece {
    
    override func isLegalMove(_ new_i: Int, _ new_j: Int, _ board: BoardViewModel) -> Bool {
     //a knight can move 8 positions at max without being bothered by other pieces
        
        if       self.i + 2 == new_i && self.j + 1 == new_j && board[new_i, new_j]?.team != self.team{
            return true
        }else if self.i + 2 == new_i && self.j - 1 == new_j && board[new_i, new_j]?.team != self.team{
            return true
        }else if self.i - 2 == new_i && self.j + 1 == new_j && board[new_i, new_j]?.team != self.team{
            return true
        }else if self.i - 2 == new_i && self.j - 1 == new_j && board[new_i, new_j]?.team != self.team{
            return true
        }else if self.i + 1 == new_i && self.j + 2 == new_j && board[new_i, new_j]?.team != self.team{
            return true
        }else if self.i + 1 == new_i && self.j - 2 == new_j && board[new_i, new_j]?.team != self.team{
            return true
        }else if self.i - 1 == new_i && self.j + 2 == new_j && board[new_i, new_j]?.team != self.team{
            return true
        }else if self.i - 1 == new_i && self.j - 2 == new_j && board[new_i, new_j]?.team != self.team{
            return true
        }
        return false
    }
}
