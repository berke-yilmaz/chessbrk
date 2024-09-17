//
//  PieceView.swift
//  chessbrk
//
//  Created by berke on 22.08.2024.
//

import SwiftUI

struct PieceView: View {
    let piece: Piece
    let isSelected: Bool
    var body: some View {
            Rectangle()
                .fill(isSelected ? Color.green.opacity(0.7) : Color.clear)
            if piece is Rook {
                Image(piece.team == "white" ? "white-rook" : "black-rook")
                    .resizable()
            } else if piece is Knight {
                Image(piece.team == "white" ? "white-knight" : "black-knight")
                    .resizable()
            } else if piece is Bishop {
                Image(piece.team == "white" ? "white-bishop" : "black-bishop")
                    .resizable()
            } else if piece is Queen {
                Image(piece.team == "white" ? "white-queen" : "black-queen")
                    .resizable()
            } else if piece is King {
                Image(piece.team == "white" ? "white-king" : "black-king")
                    .resizable()
            } else if piece is Pawn {
                Image(piece.team == "white" ? "white-pawn" : "black-pawn")
                    .resizable()
            }
        }
}

#Preview {
    PieceView(piece: King(7, 4, "white", 0), isSelected: true)
}
