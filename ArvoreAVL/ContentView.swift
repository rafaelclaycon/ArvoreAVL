//
//  ContentView.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 17/09/20.
//

import SwiftUI

struct ContentView: View {
    @State private var entrada = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Árvore AVL de Inteiros")
                .font(.title)
                .bold()
                .padding()
                .padding(.leading, 10)
            
            Spacer()
            
            HStack {
                Spacer()
                
                TextField("Número inteiro", text: $entrada)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 150)
                    .padding(.trailing, 20)
                
                Button(action: {
                    print("Número adicionado à árvore.")
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Adicionar")
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 1.0)
                    )
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
