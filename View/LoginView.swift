import SwiftUI

struct LoginView: View {
    @ObservedObject private var loginViewModel = LoginViewModel()
    @State private var path = NavigationPath()
    
    @State private var showToast = false
    @State private var toastMessage = ""
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor(named: "StrongPurple") ?? .purple),
                        Color(UIColor(named: "PurpleNormal") ?? .purple),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("Entre na sua conta")
                                .font(.title)
                                .fontWeight(.bold)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("E-mail")
                                .font(.headline)
                                .foregroundColor(Color(UIColor(named: "StyledLightGray") ?? .gray))
                                .fontWeight(.regular)
                                .padding([.leading], 4)
                            TextField("Email", text: $loginViewModel.email)
                                .font(.custom("input-sm", size: 16))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(UIColor(named: "StyledLightPurple") ?? .purple), lineWidth: 3)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack() {
                                Text("Senha")
                                    .font(.headline)
                                    .foregroundColor(Color(UIColor(named: "StyledLightGray") ?? .gray))
                                    .fontWeight(.regular)
                                    .padding([.leading], 4)
                                Spacer()
                                
                                Text("Recuperar senha")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .fontWeight(.regular)
                                    .padding([.leading], 4)
                            }
                            
                            SecureField("Password", text: $loginViewModel.password)
                                .font(.custom("input-sm", size: 16))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(UIColor(named: "StyledLightPurple") ?? .purple), lineWidth: 3)
                                )
                        }
                        
                        HStack() {
                            Text("Lembrar minha senha")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor(named: "StyledLightGray") ?? .gray))
                                .fontWeight(.regular)
                                .padding([.leading], 4)
                            Spacer()
                            
                            Toggle("", isOn: $loginViewModel.savePassword)
                                .toggleStyle(CheckmarkToggleStyle())
                        }
                        
                        if (loginViewModel.errorMessage != nil && loginViewModel.isAuthenticating == false) {
                            Text(String(loginViewModel.errorMessage ?? "E-mail ou senha incorretos"))
                                .foregroundColor(.red)
                        }
                        
                        if loginViewModel.isAuthenticating == true {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                        }
                        
                        Button(action: loginViewModel.loginUser) {
                            Text("Entrar")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(UIColor(named: "PurpleNormal") ?? .purple))
                                .cornerRadius(8)
                        }
                        
                        Button(action: loginViewModel.loginUser) {
                            HStack() {
                                Image(systemName: "applelogo").foregroundColor(.white)
                                Text("Continuar com Apple")
                                
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(8)
                        }
                        
                        HStack() {
                            Text("Não possui uma conta?")
                                .font(.headline)
                                .foregroundColor(Color(UIColor(named: "StyledLightGray") ?? .gray))
                                .fontWeight(.regular)
                                .padding([.leading], 4)
                            
                            NavigationLink(destination: SignUpView(loginViewModel: loginViewModel)) {
                                Text("Cadastre-se")
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
                    
                    ToastView(message: toastMessage, isPresented: $showToast)
                        .padding(.bottom, 50)
                }
                .ignoresSafeArea()
                .navigationDestination(isPresented: $loginViewModel.isAuthenticated) {
                    SegmentListView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(NotificationCenter.default.publisher(for: .registrationSuccessful)) { _ in
            showToast = true
            toastMessage = "Cadastro realizado com sucesso!"
        }
        .onAppear {
            if loginViewModel.isSignedUp {
                showToast = true
                toastMessage = "Cadastro realizado com sucesso!"
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CheckmarkToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? .green : .gray)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.easeInOut(duration: 4), value: false)
                    
                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

extension Notification.Name {
    static let registrationSuccessful = Notification.Name("registrationSuccessful")
}
