import SwiftUI

struct PromotionView: View {
    @Binding var selectedPiece: Piece?
    @Binding var isPresented: Bool
    var team: String
    var i: Int
    var j: Int

    var body: some View {
        VStack {
            Text("Choose a piece for promotion")
                .font(.title2)

            HStack {
                Button(action: { selectPiece(Queen(i, j, team, 9)) }) {
                    Image(team == "white" ? "white-queen" : "black-queen")
                        .resizable()
                        .frame(width: 60, height: 60)
                        
                }
                Button(action: { selectPiece(Rook(i, j, team, 5)) }) {
                    Image(team == "white" ? "white-rook" : "black-rook")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                Button(action: { selectPiece(Bishop(i, j, team, 3)) }) {
                    Image(team == "white" ? "white-bishop" : "black-bishop")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                Button(action: { selectPiece(Knight(i, j, team, 3)) }) {
                    Image(team == "white" ? "white-knight" : "black-knight")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
            }
            .padding()
        }
    }

    private func selectPiece(_ piece: Piece) {
        selectedPiece = piece
        isPresented = false
    }
}

struct PromotionView_Previews: PreviewProvider {
    @State static var selectedPiece: Piece? = Pawn(6, 2, "white", 1)
    @State static var isPresented: Bool = true

    static var previews: some View {
        PromotionView(selectedPiece: $selectedPiece, isPresented: $isPresented, team: "white", i: 6, j: 2)
    }
}
