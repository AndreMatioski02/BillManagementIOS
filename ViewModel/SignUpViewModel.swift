import Foundation

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var phone: String = ""
    @Published var cpf: String = ""
    @Published var isSigningUp = false
    @Published var errorMessage: String?
    private var loginViewModel: LoginViewModel
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
    }
    
    func signUpUser() {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty, !phone.isEmpty, !cpf.isEmpty else {
            self.errorMessage = "Por favor, preencha todos os campos."
            return
        }
        
        guard isValidEmail(email) else {
            self.errorMessage = "E-mail inválido."
            return
        }
        
        guard isValidCPF(cpf) else {
            self.errorMessage = "CPF inválido."
            return
        }
        
        guard isValidPhone(phone) else {
            self.errorMessage = "Telefone inválido."
            return
        }
        self.isSigningUp = true
        
        FirebaseSignUpService.shared.signUp(email: email, password: password, name: name, phone: phone, cpf: cpf) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.loginViewModel.isSignedUp = true
                case .failure(_):
                    self?.errorMessage = "E-mail já existente"
                    
                }
                
                self?.isSigningUp = false
                
            }
        }
    }
    
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func isValidCPF(_ cpf: String) -> Bool {
    return cpf.count == 14
}

func isValidPhone(_ phone: String) -> Bool {
    return phone.count == 15
}
