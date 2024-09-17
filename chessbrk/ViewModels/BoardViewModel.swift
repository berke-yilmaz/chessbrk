import SwiftUI
import AVFoundation

    class BoardViewModel: ObservableObject {
        @Published var board2D: [[Piece?]]
        @Published  var turn: String
        @Published var isKingInCheck: Bool = false
        @Published var moveHistory: [Move] = []  // Stack to keep track of move history
        @Published var gameMessage: String

        init() {
            
            self.gameMessage = "continue"
            self.turn = "white"
            self.board2D = Array(repeating: Array(repeating: nil, count: 8), count: 8)
            let whiteRook1   = Rook(7, 0, "white",5)
            let whiteRook2   = Rook(7, 7, "white",5)
            let whiteKnight1 = Knight(7, 1, "white",3)
            let whiteKnight2 = Knight(7, 6, "white",3)
            let whiteBishop1 = Bishop(7, 2, "white",3)
            let whiteBishop2 = Bishop(7, 5, "white",3)
            let whiteQueen   = Queen(7, 3, "white",9)
            let whiteKing    = King(7, 4, "white",0)
            
            let whitePawn1   = Pawn(6, 0, "white",1)
            let whitePawn2   = Pawn(6, 1, "white",1)
            let whitePawn3   = Pawn(6, 2, "white",1)
            let whitePawn4   = Pawn(6, 3, "white",1)
            let whitePawn5   = Pawn(6, 4, "white",1)
            let whitePawn6   = Pawn(6, 5, "white",1)
            let whitePawn7   = Pawn(6, 6, "white",1)
            let whitePawn8   = Pawn(6, 7, "white",1)
            
            let blackRook1   = Rook(0, 0, "black",5)
            let blackRook2   = Rook(0, 7, "black",5)
            let blackKnight1 = Knight(0, 1, "black",3)
            let blackKnight2 = Knight(0, 6, "black",3)
            let blackBishop1 = Bishop(0, 2, "black",3)
            let blackBishop2 = Bishop(0, 5, "black",3)
            let blackQueen   = Queen(0, 3, "black",9)
            let blackKing    = King(0, 4, "black",0)
            
            let blackPawn1   = Pawn(1, 0, "black",1)
            let blackPawn2   = Pawn(1, 1, "black",1)
            let blackPawn3   = Pawn(1, 2, "black",1)
            let blackPawn4   = Pawn(1, 3, "black",1)
            let blackPawn5   = Pawn(1, 4, "black",1)
            let blackPawn6   = Pawn(1, 5, "black",1)
            let blackPawn7   = Pawn(1, 6, "black",1)
            let blackPawn8   = Pawn(1, 7, "black",1)
            
            let pieces = [
                whiteRook1, whiteRook2, whiteKnight1, whiteKnight2,
                whiteBishop1, whiteBishop2, whiteQueen, whiteKing,
                whitePawn1, whitePawn2, whitePawn3, whitePawn4,
                whitePawn5, whitePawn6, whitePawn7, whitePawn8,
                blackRook1, blackRook2, blackKnight1, blackKnight2,
                blackBishop1, blackBishop2, blackQueen, blackKing,
                blackPawn1, blackPawn2, blackPawn3, blackPawn4,
                blackPawn5, blackPawn6, blackPawn7, blackPawn8
            ]
//            let pieces = [
//                whiteBishop1, whiteBishop2, whiteQueen, whiteKing,
//                blackBishop1, blackBishop2, blackQueen, blackKing,
//            
//            ]
            
            for piece in pieces {
                self.setPiece(piece)
            }

        }
        
        func checkThreeTimesRepeatDraw() -> Bool {
            // Ensure there are at least 6 moves in the history (3 full turns)
            guard moveHistory.count >= 6 else {
                return false
            }
            
            // Get the last 6 moves (3 for each player)
            let lastSixMoves = Array(moveHistory.suffix(6))
            
            // Compare each pair of moves: (0, 2, 4) with (1, 3, 5)
                let zeroMove = lastSixMoves[0]
                let firstMove =  lastSixMoves[1]
                let secondMove = lastSixMoves[2]
                let thirdMove = lastSixMoves[3]
                let fourthMove = lastSixMoves[4]
                let fifthMove = lastSixMoves[5]
                
                if !areMovesEqual(move1: zeroMove, move2: fourthMove) && !areMovesEqual(move1: firstMove, move2: fifthMove) {
                    return false
                }
            
            
            // If all three pairs of moves are equal, it's a threefold repetition
            return true
        }

        private func areMovesEqual(move1: Move, move2: Move) -> Bool {
            return move1.startX == move2.startX &&
                   move1.startY == move2.startY &&
                   move1.endX == move2.endX &&
                   move1.endY == move2.endY &&
                   move1.piece.team == move2.piece.team &&
                   move1.capturedPiece?.team == move2.capturedPiece?.team
        }

        
        func isMatePossible(player: PlayerViewModel) -> Bool {
            // Count the number of each type of piece the player has
            var queenCount = 0
            var rookCount = 0
            var knightCount = 0
            var bishopCount = 0

            for piece in player.piecesOnBoard {
                if piece is Queen {
                    queenCount += 1
                } else if piece is Rook {
                    rookCount += 1
                } else if piece is Knight {
                    knightCount += 1
                } else if piece is Bishop {
                    bishopCount += 1
                }
            }

            // Check conditions where mate is possible:
            // - At least one queen
            // - At least one rook
            // - Two knights or more (checkmate with two knights is theoretically possible but extremely rare)
            // - Two bishops or more (on different colors)
            // - One bishop and one knight
            if queenCount > 0 || rookCount > 0 {
                return true
            }
            if knightCount >= 2 || bishopCount >= 2 {
                return true
            }
            if knightCount >= 1 && bishopCount >= 1 {
                return true
            }

            // If none of the conditions are met, mate is not possible
            return false
        }
        
        func checkEndGame(player1: PlayerViewModel, player2: PlayerViewModel) -> String {
            
            player1.checkIfAnyMoveIsPossible(board: self)
            player2.checkIfAnyMoveIsPossible(board: self)
            var endStatus: String = "continue"
            
            if turn == "white" {
                if !player1.hasMoves {
                    if isKingInCheck {
                        endStatus = "black"  // White is checkmated
                    } else if !isKingInCheck {
                        endStatus = "draw"  // Stalemate
                    }
                    
                }
            }else if turn == "black" {
                    if !player2.hasMoves {
                        if isKingInCheck{
                            endStatus = "white"  // Black is checkmated
                        } else if !isKingInCheck {
                            endStatus = "draw"  // Stalemate
                        }
                    }
            }
            if(endStatus == "continue"){
                if !(isMatePossible(player: player1) || isMatePossible(player: player2)){
                    endStatus = "draw"
                }
            }
            if checkThreeTimesRepeatDraw() {
                   endStatus = "draw"
               }
    
            return endStatus
        }
        
        func movePiece(piece: Piece, to newX: Int, to newY: Int, player1: PlayerViewModel, player2: PlayerViewModel) {
            
            guard newX >= 0 && newX < 8 && newY >= 0 && newY < 8 else {
                print("Move out of bounds")
                return
            }
            if piece.team != turn {
                print("Wait for your turn")
                return
            }
            
            let startI = piece.i
            let startJ = piece.j
            
            if let capturedPiece = board2D[newX][newY] {
                if capturedPiece.team != piece.team {
                    if capturedPiece.team == "white" {
                        player1.capturePiece(capturedPiece) //update their arrays
                    } else {
                        player2.capturePiece(capturedPiece)
                    }
                }
            }
            
            if let king = piece as? King, abs(newY - king.j) == 2 {
                // Castle condition
                king.castle(to: newX, newY: newY, board: self)
                king.hasMoved = true
            } else {
                // General move logic
                if let king = piece as? King {
                    king.hasMoved = true
                } else if let rook = piece as? Rook {
                    rook.hasMoved = true
                }
                
                // Reset en passant flags for opponent pawns
                if let pawn = piece as? Pawn {
                    pawn.fixPawnLogic(newX, newY, self)
                }
                resetEnPassantFlags(for: piece.team == "white" ? "black" : "white")
                
                // Clear old position
                board2D[startI][startJ] = nil
                
                // Set new position
                if(board2D[newX][newY] == nil){
                    SoundManager.playSystemSound(named: "move-self")
                }else{
                    SoundManager.playSystemSound(named: "capture")
                }
                
                
                piece.i = newX
                piece.j = newY
                piece.currentX = CGFloat(newY)  // Adjusted to reflect correct coordinates
                piece.currentY = CGFloat(newX)  // Adjusted to reflect correct coordinates
                
                // Update board
                board2D[newX][newY] = piece
            }
            
            let move = Move(piece: piece, startX: startI, startY: startJ, endX: newX, endY: newY, capturedPiece: board2D[newX][newY], isFirstMove: piece.isFirstMove)
            moveHistory.append(move)
            
            // Update game state
            
            switchTurn()
            checkKingSafety()
            
            // Check if the game should end
            let endStatus = checkEndGame(player1: player1, player2: player2)
            handleEndGameStatus(endStatus)
            objectWillChange.send() // Notify observers that the board has changed
            
        }

        func handleEndGameStatus(_ status: String) {
            switch status {
            case "white":
                print("Player 1 (White) wins!")
                gameMessage = "Player 1 (White) wins!"
                SoundManager.playSystemSound(named: "game-end")
            case "black":
                print("Player 2 (Black) wins!")
                // Add any UI update or logic to handle the end of the game
                gameMessage = "Player 2 (Black) wins!"
                SoundManager.playSystemSound(named: "game-end")
            case "draw":
                print("The game is a draw!")
                gameMessage = "The game is a draw!"
                SoundManager.playSystemSound(named: "game-end")
                // Add any UI update or logic to handle the end of the game
            default:
                gameMessage = "continue"
                break
            }
        }
        
        func setPiece(_ piece: Piece) {
            guard piece.i >= 0 && piece.i < 8 && piece.j >= 0 && piece.j < 8 else {
                //   print("Invalid position")
                return
            }
            board2D[piece.i][piece.j] = piece  // Correct the indexing here
        }
        
        func getPiece(atRow row: Int, column: Int) -> Piece? {
            guard row >= 0 && row < 8 && column >= 0 && column < 8 else {
                //     print("Invalid position")
                return nil
            }
            
            return board2D[row][column]
        }
        
        subscript(row: Int, column: Int) -> Piece? {
            get {
                guard row >= 0 && row < 8 && column >= 0 && column < 8 else {
                    //print("Index out of bounds")
                    return nil
                }
                return board2D[row][column]
            }
            set {
                guard row >= 0 && row < 8 && column >= 0 && column < 8 else {
                    //print("Index out of bounds")
                    return
                }
                board2D[row][column] = newValue
            }
        }
        
        func resetEnPassantFlags(for team: String) {
            for row in board2D {
                for piece in row {
                    if let pawn = piece as? Pawn, pawn.team == team {
                        pawn.resetEnPassantFlag()
                    }
                }
            }
        }
        
        func checkKingSafety() {
            if let kingPosition = findKingPosition(for: turn) {
                self.isKingInCheck = isPositionUnderAttack(i: kingPosition.0, j: kingPosition.1, team: turn)
            }
        }
        
        private func findKingPosition(for team: String) -> (Int, Int)? {
            for (i, row) in board2D.enumerated() {
                for (j, piece) in row.enumerated() {
                    if let piece = piece, piece is King, piece.team == team {
                        return (i, j)
                    }
                }
            }
            return nil
        }
        
        func findKing(for team: String) -> King? {
            for row in board2D {
                for piece in row {
                    if let king = piece as? King, king.team == team {
                        return king
                    }
                }
            }
            return nil
        }
        
        func switchTurn() {
            turn = (turn == "white" ? "black" : "white")
        }
        
        func isPositionUnderAttack(i: Int, j: Int,team: String) -> Bool {
            // Loop through all pieces on the board
            for row in 0..<8 {
                for col in 0..<8 {
                    if let piece = self.getPiece(atRow: row, column: col), piece.team != team {
                        // Check if this piece can move to (i, j)
                        if piece.isLegalMove(i, j, self) {
                            return true
                        }
                    }
                }
            }
            return false
        }
        
    }
    
