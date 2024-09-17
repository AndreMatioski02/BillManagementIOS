import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    func loginUser() {
        FirebaseAuthService.shared.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.isAuthenticated = true
                    print("Logged in as: \(user.email ?? "")")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signOut() {
        FirebaseAuthService.shared.signOut { [weak self] result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self?.isAuthenticated = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
