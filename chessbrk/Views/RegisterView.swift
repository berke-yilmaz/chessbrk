import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var isLoggingIn = false

    var body: some View {
        if isLoggingIn {
            ProgressView()
        }
        VStack{
            //header
            HeaderView(title: "Kayıt", subtitle: "brk'yi yenebilecek misin?", angle: -16, background: .green)
            
            Form {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                
                TextField("Kullanıcı Adı", text: $viewModel.username)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                TextField("Email Adresi", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                SecureField("Şifre", text: $viewModel.password)
                    .autocapitalization(.none)
                    .textFieldStyle(DefaultTextFieldStyle())
                
          
                TLButton(title: "Kayıt Ol", background: .green) {
                    isLoggingIn = true
                    Task.init{
                        await viewModel.register(email: viewModel.email, password: viewModel.password, username: viewModel.username)
                        isLoggingIn = false
                    }
                }
                .disabled(isLoggingIn)
            
            }
            .offset(y: -50)
            
            Spacer()
        }
    }
}

#Preview {
    RegisterView()
}
