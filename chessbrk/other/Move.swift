//
//  Move.swift
//  chessbrk
//
//  Created by berke on 19.08.2024.
//

import Foundation

struct Move {
    let piece: Piece
    let startX: Int
    let startY: Int
    let endX: Int
    let endY: Int
    let capturedPiece: Piece?
    let isFirstMove: Bool
}
