import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedObject var app: RealmSwift.App
    @EnvironmentObject var errorHandler: ErrorHandler
    @AppStorage("username") private var username: String = ""

    var body: some View {
        if let user = app.currentUser {
            let config = user.flexibleSyncConfiguration(initialSubscriptions: { subs in
            })
            VStack {
                // Show the main app content (e.g., OpenRealmView)
                
                OpenRealmView(user: user)
                    .environment(\.realmConfiguration, config)
                
                // Add a logout button
                Button(action: logout) {
                    Text("Çıkış Yap")
                }
                .padding()
                .buttonStyle(BetterButtonStyle(color: Color.red))
            }
        } else {
            // Show login view if no user is logged in
            LoginView()
        }
    }

    // Function to handle logout
    private func logout() {
        Task {
            do {
                try await app.currentUser?.logOut()
                print("Logged out successfully")
            } catch {
                print("Failed to log out: \(error.localizedDescription)")
            }
        }
    }
}
