import SwiftUI

struct GameOverView: View {
    var gameMessage: String
    var onRestart: () -> Void // Callback to trigger restart
    @Binding var isPresented: Bool // Binding to control visibility
    
    var body: some View {
        GeometryReader { geometry in
            let boardSize = min(geometry.size.width, geometry.size.height)
            
            VStack {
                Text(gameMessage)
                    .font(.title)
                    .foregroundStyle(Color.black)
               
                Button(action: {
                    isPresented = false // Close the view
                    onRestart() // Perform the restart action
                    print("yeniden oyna")
                }, label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Restart Game")
                    }
                })
                .buttonStyle(BetterButtonStyle(color: Color.blue))
            }
            .frame(maxWidth: boardSize / 1.2, maxHeight: boardSize / 3)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center within the full space
        }
    }
}


struct GameOverView_Previews: PreviewProvider {
    @State static var isPresented = true // Example state for showing the view

    static var previews: some View {
        GameOverView(
            gameMessage: "Player 1 (White) wins!",
            onRestart: {
                print("Restart triggered")
            },
            isPresented: $isPresented
        )
        .previewLayout(.sizeThatFits) // Adjusts the preview to fit the view's size
    }
}
