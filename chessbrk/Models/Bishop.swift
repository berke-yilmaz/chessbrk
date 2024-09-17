import Foundation

class Bishop: Piece {

    override func isLegalMove(_ new_i: Int, _ new_j: Int, _ board: BoardViewModel) -> Bool {
        // Determine if the move is diagonal
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
}
