import SwiftUI
import Combine

class BeginViewModel: ObservableObject {
    @Published var gameMode: String = ""

    
    func selectGameMode(mode: String) {
        self.gameMode = mode

        // If additional setup is required based on the mode, handle it here
        if gameMode == "self" {
            // Configure for self-play, perhaps different settings
        } else if gameMode == "ai" {
            // Configure AI settings
        } else if gameMode == "online" {
            // Prepare for online gameplay
        }

        // Transition to GameView or other appropriate views can be handled here or via NavigationLink in SwiftUI
    }
}
