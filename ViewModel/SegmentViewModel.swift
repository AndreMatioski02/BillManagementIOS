import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Segment: Identifiable {
    let id: String
    let title: String
    let description: String
}

class SegmentViewModel: ObservableObject {
    @Published var segments: [Segment] = []
    @Published var showModalEditAndCreate = false
    @Published var showModalDelete = false
    
    private var service = SegmentService()
    private var userId: String?

    init() {
        fetchUserId()
        fetchSegments()
    }

    func fetchUserId() {
        if let user = Auth.auth().currentUser {
            self.userId = user.uid
        }
    }

    func fetchSegments() {
        guard let userId = userId else { return }
        service.getSegments(for: userId) { [weak self] segments in
            self?.segments = segments
        }
    }

    func addSegment(title: String, description: String) {
        guard let userId = userId else { return }
        service.createSegment(for: userId, title: title, description: description) {
            self.fetchSegments()
        }
    }

    func updateSegment(segment: Segment, title: String, description: String) {
        guard let userId = userId else { return }
        service.updateSegment(for: userId, segment: segment, title: title, description: description) {
            self.fetchSegments()
        }
    }

    func deleteSegment(segmentId: String) {
        guard let userId = userId else { return }
        service.deleteSegment(for: userId, segmentId: segmentId) {
            self.fetchSegments()
            self.showModalDelete = false
        }
    }
}

