import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Bill: Identifiable {
    let id: String
    let title: String
    let description: String
    let value: Double
}

class BillViewModel: ObservableObject {
    @Published var bills: [Bill] = []
    @Published var showModalEditAndCreateBill = false
    @Published var showModalDeleteBill = false
    
    @Published var totalValue: Double = 0.0
    
    private var service = BillService()
    private var userId: String?
    
    private var segmentId: String
    
    init(segmentId: String) {
        self.segmentId = segmentId
        fetchUserId()
        fetchBills()
    }
    
    func fetchUserId() {
        if let user = Auth.auth().currentUser {
            self.userId = user.uid
        }
    }
    
    func fetchBills() {
        guard let userId = userId else { return }
        service.getBills(for: userId, for: segmentId) { [weak self] bills in
            self?.bills = bills
            self?.totalValue = bills.reduce(0) { $0 + $1.value }
        }
    }
    
    func addBill(segmentId: String, title: String, description: String, value: Double) {
        guard let userId = userId else { return }
        service.createBill(for: userId, segmentId: segmentId, title: title, description: description, value: value) {
            self.fetchBills()
        }
    }
    
    func updateBill(segmentId: String, billId: String, title: String, description: String, value: Double) {
        guard let userId = userId else { return }
        service.updateBill(for: userId, segmentId: segmentId, billId: billId, title: title, description: description, value: value) {
            self.fetchBills()
        }
    }
    
    func deleteBill(segmentId: String, billId: String) {
        guard let userId = userId else { return }
        service.deleteBill(for: userId, segmentId: segmentId, billId: billId) {
            self.fetchBills()
            self.showModalDeleteBill = false
        }
    }
}

