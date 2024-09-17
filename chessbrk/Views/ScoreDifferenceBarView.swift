//
//  ScoreDifferenceBar.swift
//  chessbrk
//
//  Created by berke on 19.08.2024.
//

import SwiftUI

struct ScoreDifferenceBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var player1: PlayerViewModel
    @ObservedObject var player2: PlayerViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Rectangle()
                    .fill(colorScheme == .dark ? Color.white : Color.gray.opacity(0.15))
                    .frame(width: widthForPlayer1(in: geometry), height: 30)
                    .animation(.easeInOut(duration: 0.3), value: player1.totalPoints) // Smooth transition
                               
                Rectangle()
                    .fill(Color.gray.opacity(0.8))
                    .frame(width: widthForPlayer2(in: geometry), height: 30)
                    .animation(.easeInOut(duration: 0.3), value: player2.totalPoints) // Smooth transition
                     }
            .cornerRadius(10)
            .animation(.easeInOut(duration: 0.3), value: player1.totalPoints + player2.totalPoints) // Animate the whole view when total points change
        }
        .frame(height: 0)
    }
    
    private func widthForPlayer1(in geometry: GeometryProxy) -> CGFloat {
        let totalWidth = geometry.size.width
        let totalScore = max(player1.totalPoints + player2.totalPoints, 1)
        return totalWidth * CGFloat(player1.totalPoints) / CGFloat(totalScore)
    }
    
    private func widthForPlayer2(in geometry: GeometryProxy) -> CGFloat {
        let totalWidth = geometry.size.width
        let totalScore = max(player1.totalPoints + player2.totalPoints, 1)
        return totalWidth * CGFloat(player2.totalPoints) / CGFloat(totalScore)
    }
}

#Preview {
    //send in already created values
    ScoreDifferenceBarView(player1: PlayerViewModel(board: BoardViewModel(), color: "white"), player2: PlayerViewModel(board: BoardViewModel(), color: "black"))
}
