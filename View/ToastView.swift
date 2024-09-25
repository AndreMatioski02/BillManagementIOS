import SwiftUI

struct ToastView: View {
    var message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            Text(message)
                .padding()
                .background(Color.green.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
                .transition(.slide)
                .animation(.easeInOut, value: isPresented)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
        }
    }
}
