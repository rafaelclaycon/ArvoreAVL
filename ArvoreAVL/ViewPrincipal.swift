//
//  ContentView.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 17/09/20.
//

import SwiftUI

struct ViewPrincipal: View {
    @ObservedObject var viewModel: ViewPrincipalViewModel
    @State private var entrada = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Árvore AVL de Inteiros 🌳")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 1)
                        
                    //Text("ACEITA INTEIROS DE -999 A 999")
                    Text("TRABALHO DO GRAU A - ESTRUTURAS AVANÇADAS DE DADOS I")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .padding(.leading, 10)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Rafael Claycon Schmitt")
                        .font(.headline)
                        .padding(.bottom, 1)
                        
//                    Text("TRABALHO DO GRAU A - ESTRUTURAS AVANÇADAS DE DADOS I")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
                }
                .padding()
                .padding(.leading, 10)
            }
            
            Spacer()
            
            VStack {
                //Text("Essa é uma mensagem de status.")
                
                HStack {
                    Spacer()
                    
                    TextField("Número", text: $entrada)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 120)
                        .padding(.trailing, 20)
                    
                    Button(action: {
                        viewModel.inserir(Int(entrada)!)
                        print("Número adicionado à árvore.")
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Inserir")
                        }
                    }
                    .buttonStyle(EstiloBordaComContorno())
                    .foregroundColor(.blue)
                    .padding(.trailing, 20)
                    
                    Button(action: {
                        print("Número adicionado à árvore.")
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Buscar")
                        }
                    }
                    .buttonStyle(EstiloBordaComContorno())
                    .foregroundColor(.blue)
                    .padding(.trailing, 20)
                    
                    Button(action: {
                        print("Número adicionado à árvore.")
                    }) {
                        HStack {
                            Image(systemName: "minus")
                            Text("Remover")
                        }
                    }
                    .buttonStyle(EstiloBordaComContorno())
                    .foregroundColor(.red)
                    .padding(.trailing, 20)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct ViewPrincipal_Previews: PreviewProvider {
    static var previews: some View {
        ViewPrincipal(viewModel: ViewPrincipalViewModel())
    }
}
