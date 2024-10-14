import FirebaseFirestore

class SegmentService {
    let db = Firestore.firestore()

    func getSegmentById(for userId: String, segmentId: String, completion: @escaping (Segment?) -> Void) {
        db.collection("users").document(userId).collection("segments").document(segmentId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching segment: \(error)")
                completion(nil)
                return
            }

            guard let doc = snapshot else {
                print("Document does not exist")
                completion(nil)
                return
            }

            guard let data = doc.data(),
                  let title = data["title"] as? String,
                  let description = data["description"] as? String else {
                print("Document data is invalid")
                completion(nil)
                return
            }

            let segment = Segment(id: doc.documentID, title: title, description: description)
            completion(segment)
        }
    }

    
    func getSegments(for userId: String, completion: @escaping ([Segment]) -> Void) {
        db.collection("users").document(userId).collection("segments").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching segments: \(error)")
                return
            }

            let segments = snapshot?.documents.compactMap { doc -> Segment? in
                let data = doc.data()
                guard let title = data["title"] as? String,
                      let description = data["description"] as? String else { return nil }

                return Segment(id: doc.documentID, title: title, description: description)
            } ?? []
            completion(segments)
        }
    }

    func createSegment(for userId: String, title: String, description: String, completion: @escaping () -> Void) {
        let newSegment = ["title": title, "description": description]
        db.collection("users").document(userId).collection("segments").addDocument(data: newSegment) { error in
            if let error = error {
                print("Error creating segment: \(error)")
            } else {
                completion()
            }
        }
    }
    
    func updateSegment(for userId: String, segment: Segment, title: String, description: String, completion: @escaping () -> Void) {
            let updatedData = ["title": title, "description": description]
            db.collection("users").document(userId).collection("segments").document(segment.id).updateData(updatedData) { error in
                if let error = error {
                    print("Error updating segment: \(error)")
                } else {
                    completion()
                }
            }
        }

    func deleteSegment(for userId: String, segmentId: String, completion: @escaping () -> Void) {
        db.collection("users").document(userId).collection("segments").document(segmentId).delete { error in
            if let error = error {
                print("Error deleting segment: \(error)")
            } else {
                completion()
            }
        }
    }
}
