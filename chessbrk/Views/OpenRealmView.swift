import SwiftUI
import RealmSwift

// MARK: - OpenRealmView
struct OpenRealmView: View {
    @AutoOpen(appId: "chessbrk-onlinemode-elwxsyu", timeout: 2000) var autoOpen
    @State var user: User
    @State var isInOfflineMode = false
    @Environment(\.realmConfiguration) private var config

    var body: some View {
        switch autoOpen {
        case .connecting:
            ProgressView("Connecting...")
        case .waitingForUser:
            ProgressView("Waiting for user...")
        case .open(let realm):
            BeginView(username: user.profile.email ?? "Unknown User")
                .onAppear {
                    print("Realm is open, user: \(user.profile.email ?? "Unknown User")")
                }
                .onChange(of: isInOfflineMode) { newValue in
                    let syncSession = realm.syncSession!
                    newValue ? syncSession.suspend() : syncSession.resume()
                }
        case .progress(let progress):
            ProgressView(value: progress.fractionCompleted, total: 1.0)
        case .error(let error):
            ErrorView(error: error)
        }
    }
}
