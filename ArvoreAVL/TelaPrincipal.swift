//
//  ContentView.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 17/09/20.
//

import SwiftUI

struct TelaPrincipal: View {
    @ObservedObject var viewModel: TelaPrincipalViewModel
    @State private var entrada = ""
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Árvore AVL de Inteiros 🌳🍃")
                            .font(.system(.largeTitle, design: .serif))
                            .bold()
                            .padding(.bottom, 1)
                            
                        Text("TRABALHO DO GRAU A - ESTRUTURAS AVANÇADAS DE DADOS I")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    HStack {
                        Text("Rafael Claycon Schmitt")
                            .font(.title3)
                            .padding(.trailing, 8)
                        
                        viewModel.imagemPerfil
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    .padding(.trailing, 20)
                }
                
                Spacer()
                
                if viewModel.mostarFatorBalanceamento {
                    DiagramaSubarvore(no: viewModel.raiz)
                        //.border(Color.red)
                }
                
                Spacer()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        TextField("Número", text: $entrada)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                            .padding(.trailing, 20)
                        
                        Button(action: {
                            if entrada.isInt {
                                viewModel.inserir(Int(entrada)!)
                                //print("Número adicionado à árvore.")
                                entrada = ""
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Inserir")
                            }
                        }
                        .buttonStyle(EstiloBordaComContorno())
                        .foregroundColor(.verde)
                        .padding(.trailing, 20)
                        
                        Button(action: {
                            viewModel.inserir(Int(self.entrada)!)
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
                        
                        Button(action: {
                            print("Número adicionado à árvore.")
                        }) {
                            HStack {
                                Image(systemName: "figure.walk")
                                Text("Caminhamento")
                            }
                        }
                        .buttonStyle(EstiloBordaComContorno())
                        .foregroundColor(Color(UIColor(red: 0.45, green: 0.22, blue: 0.06, alpha: 1.00)))
                        .padding(.trailing, 20)
                        
                        Toggle(isOn: $viewModel.mostarFatorBalanceamento) {
                            Text("Mostar árvore")
                        }
                        .frame(width: 180)
                        //.padding(.horizontal, 10)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            if viewModel.mostarTextoInformativo {
                Text(viewModel.status)
                    .offset(y: 285)
            }
        }
    }
}

struct TelaPrincipal_Previews: PreviewProvider {
    static var previews: some View {
        TelaPrincipal(viewModel: TelaPrincipalViewModel())
    }
}
