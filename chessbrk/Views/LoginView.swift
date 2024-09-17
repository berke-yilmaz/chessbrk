import SwiftUI
import RealmSwift
import CryptoKit

// MARK: - LoginView
struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView(title: "chessbrk", subtitle: "Satranç Oyna", angle: 16, background: .teal)
                
                // Login Form
                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                    
                    SecureField("Şifre", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)

                    TLButton(title: "Giriş Yap", background: .blue) {
                        Task.init {
                            await viewModel.login(email: viewModel.email, password: viewModel.password)
                        }
                    }
                }
                .offset(y: -50)
                
                // Create Account Link
                VStack {
                    Text("Yeni Misin?")
                    NavigationLink("Kayıt Ol", destination: RegisterView())
                }
                .padding(.bottom, 50)
                
                Spacer()
            }
        }
    }
}
