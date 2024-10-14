import FirebaseFirestore

class BillService {
    let db = Firestore.firestore()

    func getBills(for userId: String, for segmentId: String, completion: @escaping ([Bill]) -> Void) {
        db.collection("users").document(userId).collection("segments").document(segmentId).collection("bills").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching bills: \(error)")
                return
            }

            let bills = snapshot?.documents.compactMap { doc -> Bill? in
                let data = doc.data()
                guard let title = data["title"] as? String,
                      let description = data["description"] as? String else { return nil }
                
                guard let value = data["value"] as? Double else { return nil }

                return Bill(id: doc.documentID, title: title, description: description, value: value)
            } ?? []
            completion(bills)
        }
    }

    func createBill(for userId: String, segmentId: String, title: String, description: String, value: Double, completion: @escaping () -> Void) {
        let newBill: [String: Any] = ["title": title, "description": description, "value": value]
        
        db.collection("users").document(userId).collection("segments").document(segmentId).collection("bills").addDocument(data: newBill) { error in
            if let error = error {
                print("Error creating bill: \(error)")
            } else {
                completion()
            }
        }
    }
    
    func updateBill(for userId: String, segmentId: String, billId: String, title: String, description: String, value: Double ,completion: @escaping () -> Void) {
            let updatedData: [String: Any] = ["title": title, "description": description, "value": value]
        
        db.collection("users").document(userId).collection("segments").document(segmentId).collection("bills").document(billId).updateData(updatedData) { error in
                if let error = error {
                    print("Error updating bill: \(error)")
                } else {
                    completion()
                }
            }
        }

    func deleteBill(for userId: String, segmentId: String, billId: String, completion: @escaping () -> Void) {
        db.collection("users").document(userId).collection("segments").document(segmentId).collection("bills").document(billId).delete { error in
            if let error = error {
                print("Error deleting bill: \(error)")
            } else {
                completion()
            }
        }
    }
}
