//
//  DeleteModalView.swift
//  BillManagement
//
//  Created by André Vinícius Matioski on 10/10/24.
//

import SwiftUI

struct DeleteModalView: View {
    let deleteType: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Excluir \(deleteType)?")
                .font(.title)
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
                .padding()
            
            Text("Tem certeza que deseja prosseguir? Essa ação é irreversível.")
                .font(.headline)
                .padding()
            
            HStack {
                Button("Cancelar") {
                    onCancel()
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                .foregroundColor(.red)
                
                Spacer()
                
                Button("Excluir") {
                    onConfirm()
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .frame(width: 320, height: 260)
        .background(Color.white)
        .cornerRadius(20)
        .padding()
    }
}

#Preview {
    DeleteModalView(deleteType: "segmento", onConfirm: {
        print("Confirmado!")
    }, onCancel: {
        print("Cancelado!")
    })
}
