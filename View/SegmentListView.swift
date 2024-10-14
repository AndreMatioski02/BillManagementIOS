import SwiftUI

struct SegmentListView: View {
    @StateObject private var viewModel = SegmentViewModel()
    @State private var selectedSegment: Segment?
    @State private var segmentId: String?
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Segmentos")
                    .font(.largeTitle)
                    .padding()
                
                Button(action: {
                    selectedSegment = nil
                    isEditing = false
                    viewModel.showModalEditAndCreate = true
                }) {
                    Text("Criar Novo Segmento")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                List(viewModel.segments) { segment in
                    HStack {
                        NavigationLink(destination: BillListView(segmentId: segment.id)) {
                            VStack(alignment: .leading) {
                                Text(segment.title)
                                    .font(.headline)
                                    .lineLimit(1)
                                Text(segment.description)
                                    .font(.subheadline)
                                    .lineLimit(1)
                            }
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "pencil")
                                .padding()
                                .foregroundColor(.blue)
                        }.onTapGesture {
                            selectedSegment = segment
                            isEditing = true
                            viewModel.showModalEditAndCreate = true
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "trash")
                                .padding()
                                .foregroundColor(.red)
                        }.onTapGesture {
                            segmentId = segment.id
                            viewModel.showModalDelete = true
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showModalEditAndCreate) {
                CreateOrEditSegmentModalView(
                    viewModel: viewModel,
                    segment: $selectedSegment,
                    isEditing: $isEditing
                )
            }
            .alert(isPresented: $viewModel.showModalDelete) {
                Alert(
                    title: Text("Excluir segmento"),
                    message: Text("Tem certeza que deseja excluir este segmento?"),
                    primaryButton: .destructive(Text("Excluir")) {
                        viewModel.deleteSegment(segmentId: segmentId ?? "")
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
