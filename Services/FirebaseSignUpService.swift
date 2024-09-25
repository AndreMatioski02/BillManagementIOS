import FirebaseAuth
import FirebaseFirestore
import Foundation

class FirebaseSignUpService {
    
    static let shared = FirebaseSignUpService()
    
    private init() {}
    
    // Função para criar a conta e adicionar informações adicionais
    func signUp(email: String, password: String, name: String, phone: String, cpf: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let db = Firestore.firestore()
                let userData: [String: Any] = [
                    "uid": user.uid,
                    "email": email,
                    "name": name,
                    "phone": phone,
                    "cpf": cpf
                ]
                
                db.collection("users").document(user.uid).setData(userData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
}
