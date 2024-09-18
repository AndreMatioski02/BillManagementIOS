import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberLogin = false
    @Published var isAuthenticated = false
    @Published var isAuthenticating = false
    @Published var errorMessage: String?
    
    func loginUser() {
        self.isAuthenticating = true
        
        FirebaseAuthService.shared.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                    self?.email = ""
                    self?.password = ""
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                self?.isAuthenticating = false
            }
        }
    }
    
    func signOut() {
        FirebaseAuthService.shared.signOut { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.isAuthenticated = false
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
