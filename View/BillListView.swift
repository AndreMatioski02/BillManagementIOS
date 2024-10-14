import SwiftUI

struct BillListView: View {
    @StateObject private var viewModel: BillViewModel
    @StateObject private var segmentViewModel: SegmentViewModel
    @State private var selectedBill: Bill?
    @State private var isEditing = false
    
    var segmentId: String
    
    init(segmentId: String) {
        _viewModel = StateObject(wrappedValue: BillViewModel(segmentId: segmentId))
        self.segmentId = segmentId
        _segmentViewModel = StateObject(wrappedValue: SegmentViewModel())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Contas")
                    .font(.largeTitle)
                    .padding(.top, 8)
                
                Text(segmentViewModel.segmentById?.title ?? "Sem título")
                    .font(.subheadline)
                    .padding(4)
                
                Text("Total gasto: \(viewModel.totalValue, specifier: "%.2f")")
                    .font(.headline)
                
                Button(action: {
                    selectedBill = nil
                    isEditing = false
                    viewModel.showModalEditAndCreateBill = true
                }) {
                    Text("Adicionar Nova Conta")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                List(viewModel.bills) { bill in                    
                    HStack {
                    VStack(alignment: .leading) {
                        Text(bill.title)
                            .font(.headline)
                            .lineLimit(1)
                        Text(bill.description)
                            .font(.subheadline)
                            .lineLimit(1)
                        Text(String(bill.value))
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                    .padding(.vertical, 8)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "pencil")
                            .padding()
                            .foregroundColor(.blue)
                    }.onTapGesture {
                        selectedBill = bill
                        isEditing = true
                        viewModel.showModalEditAndCreateBill = true
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "trash")
                            .padding()
                            .foregroundColor(.red)
                    }
                    .onTapGesture {
                        selectedBill = bill
                        viewModel.showModalDeleteBill = true
                    }
                }
                }
            }
            .sheet(isPresented: $viewModel.showModalEditAndCreateBill) {
                CreateOrEditBillModalView(
                    viewModel: viewModel,
                    bill: $selectedBill,
                    segmentId: segmentId,
                    isEditing: $isEditing
                )
            }
            .alert(isPresented: $viewModel.showModalDeleteBill) {
                Alert(
                    title: Text("Excluir Conta"),
                    message: Text("Tem certeza que deseja excluir esta conta?"),
                    primaryButton: .destructive(Text("Excluir")) {
                        if let bill = selectedBill {
                            viewModel.deleteBill(segmentId: segmentId, billId: bill.id)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }.onAppear {
            segmentViewModel.fetchSegmentById(segmentId: segmentId)
        }
    }
}
