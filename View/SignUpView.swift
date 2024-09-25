import SwiftUI

struct SignUpView: View {
    @State private var path = NavigationPath()
    
    @ObservedObject private var loginViewModel: LoginViewModel
    @StateObject private var signUpViewModel: SignUpViewModel
    
    init(loginViewModel: LoginViewModel) {
        _signUpViewModel = StateObject(wrappedValue: SignUpViewModel(loginViewModel: loginViewModel))
        self.loginViewModel = loginViewModel
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor(red: 27/255, green: 0/255, blue: 71/255, alpha: 1)),
                        Color(red: 99/255, green: 0/255, blue: 251/255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("Crie sua conta")
                                .font(.title)
                                .fontWeight(.bold)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("E-mail")
                                .font(.headline)
                                .foregroundColor(Color(red: 93/255, green: 93/255, blue: 93/255))
                                .fontWeight(.regular)
                                .padding([.leading], 4)
                            TextField("Email", text: $signUpViewModel.email)
                                .font(.custom("input-sm", size: 16))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 220/255, green: 199/255, blue: 253/255), lineWidth: 3)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Senha")
                                .font(.headline)
                                .foregroundColor(Color(red: 93/255, green: 93/255, blue: 93/255))
                                .fontWeight(.regular)
                                .padding([.leading], 4)
                            
                            
                            
                            SecureField("Senha", text: $signUpViewModel.password)
                                .font(.custom("input-sm", size: 16))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 220/255, green: 199/255, blue: 253/255), lineWidth: 3)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Nome completo")
                                .font(.headline)
                                .foregroundColor(Color(red: 93/255, green: 93/255, blue: 93/255))
                                .fontWeight(.regular)
                                .padding([.leading], 4)
                            
                            
                            
                            TextField("Nome completo", text: $signUpViewModel.name)
                                .font(.custom("input-sm", size: 16))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 220/255, green: 199/255, blue: 253/255), lineWidth: 3)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Telefone")
                                .font(.headline)
                                .foregroundColor(Color(red: 93/255, green: 93/255, blue: 93/255))
                                .fontWeight(.regular)
                                .padding([.leading], 4)
                            
                            TextField("(00) 00000-0000", text: $signUpViewModel.phone)
                                .font(.custom("input-sm", size: 16))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 220/255, green: 199/255, blue: 253/255), lineWidth: 3)
                                )
                                .keyboardType(.numberPad)
                                .onChange(of: signUpViewModel.phone) { oldValue, newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    
                                    let maxLength = 11
                                    let limited = String(filtered.prefix(maxLength))
                                    
                                    let formatted = formatPhoneNumber(limited)
                                    
                                    signUpViewModel.phone = formatted
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CPF")
                                .font(.headline)
                                .foregroundColor(Color(red: 93/255, green: 93/255, blue: 93/255))
                                .fontWeight(.regular)
                                .padding([.leading], 4)
                            
                            TextField("000.000.000-00", text: $signUpViewModel.cpf)
                                .font(.custom("input-sm", size: 16))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 220/255, green: 199/255, blue: 253/255), lineWidth: 3)
                                )
                                .keyboardType(.numberPad)
                                .onChange(of: signUpViewModel.cpf) { oldValue, newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    
                                    let maxLength = 11
                                    let limited = String(filtered.prefix(maxLength))
                                    
                                    let formatted = formatCPF(limited)
                                    
                                    signUpViewModel.cpf = formatted
                                }
                        }
                        
                        if (signUpViewModel.errorMessage != nil && signUpViewModel.isSigningUp == false) {
                            Text((signUpViewModel.errorMessage ?? "E-mail já existente") as String)
                                .foregroundColor(.red)
                        }
                        
                        if signUpViewModel.isSigningUp == true {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                        }
                        
                        Button(action: signUpViewModel.signUpUser) {
                            Text("Cadastrar-se")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(red: 99/255, green: 0/255, blue: 251/255))
                                .cornerRadius(8)
                        }
                        
                        HStack() {
                            Text("Já possui uma conta?")
                                .font(.headline)
                                .foregroundColor(Color(red: 93/255, green: 93/255, blue: 93/255))
                                .fontWeight(.regular)
                                .padding([.leading], 4)
                            
                            NavigationLink(destination: LoginView(loginViewModel: self.loginViewModel)) {
                                Text("Entre")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .fontWeight(.regular)
                                    .padding([.leading], 4)
                            }
                        }
                        
                        
                    }
                    .padding([.top, .bottom], 32)
                    .padding([.leading, .trailing ,.bottom], 16)
                    .background(Color.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .shadow(radius: 10)
                }
                .ignoresSafeArea()
                .navigationDestination(isPresented: $loginViewModel.isSignedUp) {
                    LoginView(loginViewModel: self.loginViewModel)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

func formatPhoneNumber(_ number: String) -> String {
    var formatted = number
    
    if formatted.count > 2 {
        formatted.insert("(", at: formatted.startIndex)
        formatted.insert(")", at: formatted.index(formatted.startIndex, offsetBy: 3))
        formatted.insert(" ", at: formatted.index(formatted.startIndex, offsetBy: 4))
    }
    if formatted.count > 9 {
        formatted.insert("-", at: formatted.index(formatted.startIndex, offsetBy: 10))
    }
    
    return formatted
}

func formatCPF(_ number: String) -> String {
    var formatted = number
    
    if formatted.count > 3 {
        formatted.insert(".", at: formatted.index(formatted.startIndex, offsetBy: 3))
    }
    if formatted.count > 7 {
        formatted.insert(".", at: formatted.index(formatted.startIndex, offsetBy: 7))
    }
    if formatted.count > 11 {
        formatted.insert("-", at: formatted.index(formatted.startIndex, offsetBy: 11))
    }
    
    return formatted
}
