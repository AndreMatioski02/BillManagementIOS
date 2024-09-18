import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var path = NavigationPath()
    
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
                            Text("Entre na sua conta")
                                .font(.title)
                                .fontWeight(.bold)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("E-mail")
                                .font(.headline)
                                .foregroundColor(Color(red: 93/255, green: 93/255, blue: 93/255))
                                .fontWeight(.regular)
                                .padding([.leading], 4)
                            TextField("Email", text: $authViewModel.email)
                                .font(.custom("input-sm", size: 16))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 220/255, green: 199/255, blue: 253/255), lineWidth: 3)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack() {
                                Text("Senha")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 93/255, green: 93/255, blue: 93/255))
                                    .fontWeight(.regular)
                                    .padding([.leading], 4)
                                Spacer()
                                
                                Text("Recuperar senha")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .fontWeight(.regular)
                                    .padding([.leading], 4)
                            }
                            
                            SecureField("Password", text: $authViewModel.password)
                                .font(.custom("input-sm", size: 16))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 220/255, green: 199/255, blue: 253/255), lineWidth: 3)
                                )
                        }
                        
                        if (authViewModel.errorMessage != nil && authViewModel.isAuthenticating == false) {
                            Text("E-mail ou senha incorretos")
                                .foregroundColor(.red)
                        }
                        
                        if authViewModel.isAuthenticating == true {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                        }
                        
                        Button(action: authViewModel.loginUser) {
                            Text("Entrar")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(red: 99/255, green: 0/255, blue: 251/255))
                                .cornerRadius(8)
                        }
                        
                        Button(action: authViewModel.loginUser) {
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
                                .foregroundColor(Color(red: 93/255, green: 93/255, blue: 93/255))
                                .fontWeight(.regular)
                                .padding([.leading], 4)
                            
                            NavigationLink(destination: ContentView()) {
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
                }
                .ignoresSafeArea()
                .navigationDestination(isPresented: $authViewModel.isAuthenticated) {
                    ContentView()
                }
            }
        }
    }
}

#Preview {
    LoginView()
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
