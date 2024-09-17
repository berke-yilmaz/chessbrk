import SwiftUI
import RealmSwift
import CryptoKit

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""

    private var app: RealmSwift.App {
        return App(id: "chessbrk-onlinemode-elwxsyu") // Your MongoDB Realm App ID
    }

    // Hash the password using SHA256
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap {
            String(format: "%02x", $0)
        }
        .joined()
    }

    // Validate email, username, and password
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    private func validateFields() async -> Bool {
        if username.isEmpty || email.isEmpty || password.isEmpty {
            await updateErrorMessage("Username, email, and password cannot be empty")
            return false
        }

        if !isValidEmail(email) {
            await updateErrorMessage("Invalid email format")
            return false
        }

        return true
    }

    private func validateFieldsL() async -> Bool {
        if email.isEmpty || password.isEmpty {
            await updateErrorMessage("Email and password cannot be empty")
            return false
        }

        if !isValidEmail(email) {
            await updateErrorMessage("Invalid email format")
            return false
        }

        return true
    }

    func login(email: String, password: String) async {
        if !(await validateFieldsL()) {
            return
        }

        do {
            let user = try await app.login(credentials: Credentials.emailPassword(email: email, password: password))
            print("Successfully logged in user: \(user)")
            await updateErrorMessage("") // Clear any previous error message

            // After logging in, configure and open Realm with Flexible Sync
            do {
                _ = try await configureFlexibleSync(for: user, email: email) // Use the returned Realm instance
                // You can now work with the `realm` object if needed.
            } catch {
                print("Error configuring flexible sync: \(error.localizedDescription)")
            }
        } catch {
            await updateErrorMessage("Failed to log in: \(error.localizedDescription)")
            print("Failed to log in user: \(error.localizedDescription)")
        }
    }
    
    func register(email: String, password: String, username: String) async {
        do {
            // Register the user
            try await app.emailPasswordAuth.registerUser(email: email, password: password)
            
            // Log in after registration
            let user = try await app.login(credentials: Credentials.emailPassword(email: email, password: password))
            
            // Hash the user's password for storing in the UserProfile model
            let hashedPassword = hashPassword(password)

            // Create a UserProfile instance
            let userProfile = UserProfile(username: username, email: email, hashedPassword: hashedPassword)

            // Save the UserProfile to Realm with Flexible Sync
            do {
                let realm = try await configureFlexibleSync(for: user, email: email) // Use the returned Realm instance
                await saveUserProfile(userProfile: userProfile, realm: realm)
            } catch {
                print("Error configuring flexible sync: \(error.localizedDescription)")
            }

            await updateErrorMessage("") // Clear any error messages
            print("Successfully registered and saved user profile")
        } catch {
            await updateErrorMessage("Failed to register: \(error.localizedDescription)")
            print("Failed to register user: \(error.localizedDescription)")
        }
    }


    // Updated configureFlexibleSync method
    @MainActor
    func configureFlexibleSync(for user: User, email: String) async throws -> Realm {
        let config = user.flexibleSyncConfiguration()

        // Open Realm asynchronously to ensure it's properly initialized
        let realm = try await Realm(configuration: config)
        
        // Ensure the app is subscribed to the user's profile
        try await realm.subscriptions.update {
            // Remove existing subscription if it exists
            if let existingSubscription = realm.subscriptions.first(named: "UserProfile") {
                realm.subscriptions.remove(existingSubscription)
            }

            // Add new subscription for the UserProfile filtered by email
            realm.subscriptions.append(QuerySubscription<UserProfile>(name: "UserProfile") {
                $0.email == email
            })
        }

        return realm
    }


    // Save the UserProfile to Realm
    @MainActor
    func saveUserProfile(userProfile: UserProfile, realm: Realm) async {
        do {
            // No need to call configureFlexibleSync again, use the passed `realm` instance

            try realm.write {
                realm.add(userProfile)
            }

            print("User profile saved to Realm and will be synced to the cloud.")
        } catch {
            updateErrorMessage("Failed to save user profile: \(error.localizedDescription)")
            print("Error saving user profile: \(error.localizedDescription)")
        }
    }



    // Update the error message on the main thread
    @MainActor
    private func updateErrorMessage(_ message: String) {
        errorMessage = message
    }
}
