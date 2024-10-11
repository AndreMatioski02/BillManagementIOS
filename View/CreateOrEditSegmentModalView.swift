import SwiftUI

struct CreateOrEditSegmentModalView: View {
    @ObservedObject var viewModel: SegmentViewModel
    @Binding var segment: Segment?
    @Binding var isEditing: Bool
    @State private var title: String = ""
    @State private var description: String = ""

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

                HStack {
                    Button(action: {
                        viewModel.showModalEditAndCreate = false
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
                        if isEditing, let segment = segment {
                            viewModel.updateSegment(segment: segment, title: title, description: description)
                        } else {
                            viewModel.addSegment(title: title, description: description)
                        }
                        viewModel.showModalEditAndCreate = false
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
            .navigationTitle(isEditing ? "Editar Segmento" : "Novo Segmento")
            .onAppear {
                if let segment = segment {
                    title = segment.title
                    description = segment.description
                }
            }
        }
    }
}
