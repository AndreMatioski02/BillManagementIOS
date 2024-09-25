import SwiftUI
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberLogin = false
    @Published var isAuthenticated = false
    @Published var isSignedUp = false {
        didSet {
            if isSignedUp {
                NotificationCenter.default.post(name: .registrationSuccessful, object: nil)
            }
        }
    }
    @Published var isAuthenticating = false
    @Published var savePassword = false
    @Published var errorMessage: String?
    
    func loginUser() {
        self.isAuthenticating = true
        
        FirebaseAuthService.shared.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                    
                    if self?.savePassword == false {
                        self?.email = ""
                        self?.password = ""
                    }
                case .failure(_):
                    self?.errorMessage = "E-mail ou senha incorreto."
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
