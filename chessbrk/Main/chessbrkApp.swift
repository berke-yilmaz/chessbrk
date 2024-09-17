//
//  chessbrkApp.swift
//  chessbrk
//
//  Created by berke on 14.08.2024.
//

import SwiftUI
import Foundation
import RealmSwift

let theAppConfig = loadAppConfig()

let atlasUrl = theAppConfig.atlasUrl

let app = App(id: theAppConfig.appId, configuration: AppConfiguration(baseURL: theAppConfig.baseUrl, transport: nil))

@main
struct chessbrkApp:  SwiftUI.App {
    @StateObject var errorHandler = ErrorHandler(app: app)

    var body: some Scene {
        WindowGroup {     
            
            ContentView(app :app) // Pass it to ContentView
                .environmentObject(errorHandler)
                .alert(Text("Error"), isPresented: .constant(errorHandler.error != nil)) {
                    Button("OK", role: .cancel) { errorHandler.error = nil }
                } message: {
                    Text(errorHandler.error?.localizedDescription ?? "")
                }
                .onAppear {
                    if let atlasUrl = atlasUrl {
                        print("To view your data in Atlas, go to this link: " + atlasUrl)
                    }
                }
        }
    }
}
 
final class ErrorHandler: ObservableObject {
    @Published var error: Swift.Error?

    init(app: RealmSwift.App) {
        // Sync Manager listens for sync errors.
        app.syncManager.errorHandler = { syncError, syncSession in
            self.error = syncError
        }
    }
}
