import SwiftUI
import Combine

struct CreateOrEditBillModalView: View {
    @ObservedObject var viewModel: BillViewModel
    @Binding var bill: Bill?
    var segmentId: String
    @Binding var isEditing: Bool
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var value: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Título", text: $title)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextField("Descrição", text: $description)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextField("Valor", text: $value)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onReceive(Just(value)) { newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }

                        var finalValue: String
                        
                        if filtered.filter({ $0 == "." }).count > 1 {
                            finalValue = filtered.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
                            finalValue.append(".")
                        } else {
                            finalValue = filtered
                        }
                        
                        if finalValue != newValue {
                            self.value = finalValue
                        }
                    }
                
                HStack {
                    Button(action: {
                        viewModel.showModalEditAndCreateBill = false
                    }) {
                        Text("Cancelar")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Spacer()
                    
                    Button(action: {
                        if isEditing, let bill = bill {
                            viewModel.updateBill(segmentId: segmentId, billId: bill.id, title: title, description: description, value: Double(value) ?? 0.0)
                        } else {
                            viewModel.addBill(segmentId: segmentId, title: title, description: description, value: Double(value) ?? 0.0)
                        }
                        viewModel.showModalEditAndCreateBill = false
                    }) {
                        Text(isEditing ? "Editar" : "Criar")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle(isEditing ? "Editar conta" : "Nova conta")
            .onAppear {
                if let bill = bill {
                    title = bill.title
                    description = bill.description
                    value = String(bill.value)
                }
            }
        }
    }
}
