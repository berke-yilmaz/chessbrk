import SwiftUI

struct BetterButtonStyle: ButtonStyle {
    var color: Color // Add a color property
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(color) // Use the input color
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
