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
                        
                        Text("Número:")
                        
                        TextField("", text: $entrada)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .padding(.trailing, 30)
                        
                        // INSERÇÃO
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
                        
                        // BUSCA
                        Button(action: {
                            if entrada.isInt {
                                viewModel.buscar(valor: Int(self.entrada)!)
                                //print("Número adicionado à árvore.")
                                entrada = ""
                            }
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Buscar")
                            }
                        }
                        .buttonStyle(EstiloBordaComContorno())
                        .foregroundColor(.blue)
                        .padding(.trailing, 20)
                        .disabled(viewModel.arvoreVazia)
                        
                        // REMOÇÃO
                        Button(action: {
                            if entrada.isInt {
                                //viewModel.remover(valor: Int(self.entrada)!)
                                //print("Número removido da árvore.")
                                entrada = ""
                            }
                        }) {
                            HStack {
                                Image(systemName: "minus")
                                Text("Remover")
                            }
                        }
                        .buttonStyle(EstiloBordaComContorno())
                        .foregroundColor(.red)
                        .padding(.trailing, 20)
                        .disabled(viewModel.arvoreVazia)
                        
                        // CAMINHAMENTO
                        Button(action: {
                            viewModel.exibindoOpcoesCaminhamento = true
                            //print("Número adicionado à árvore.")
                        }) {
                            HStack {
                                Image(systemName: "figure.walk")
                                Text("Caminhamento")
                            }
                        }
                        .buttonStyle(EstiloBordaComContorno())
                        .foregroundColor(Color(UIColor(red: 0.45, green: 0.22, blue: 0.06, alpha: 1.00)))
                        .padding(.trailing, 20)
                        .disabled(viewModel.arvoreVazia)
                        .actionSheet(isPresented: $viewModel.exibindoOpcoesCaminhamento) {
                            ActionSheet(title: Text("Escolha um tipo de caminhamento:"),
                                        message: nil,
                                        buttons: [.default(Text("↩️  Pré-Ordem")) { viewModel.exibirCaminhamentoPreOrdem() },
                                                  .default(Text("↪️  Pós-Ordem")) { viewModel.exibirCaminhamentoPosOrdem() },
                                                  .default(Text("🔢  Em-Ordem")) { viewModel.exibirCaminhamentoEmOrdem() },
                                                  .cancel(Text("Cancelar"))])
                        }
                        
                        Toggle(isOn: $viewModel.mostarFatorBalanceamento) {
                            Text("Mostar árvore")
                        }
                        .frame(width: 170)
                        .padding(.leading, 10)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            if viewModel.mostarTextoInformativo {
                Text(viewModel.status)
                    .offset(y: 270)
            }
        }
    }
}

struct TelaPrincipal_Previews: PreviewProvider {
    static var previews: some View {
        TelaPrincipal(viewModel: TelaPrincipalViewModel())
    }
}
