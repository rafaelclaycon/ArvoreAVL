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
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Text("Rafael Claycon Schmitt")
                                .font(.title3)
                                .padding(.trailing, 8)
                            
                            viewModel.imagemPerfil
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                        }
                        
                        Button(action: {
                            viewModel.exibindoFerramentas = true
                        }) {
                            HStack {
                                Text("Casos de teste")
                            }
                        }
                        .disabled(!viewModel.arvoreVazia)
                        .actionSheet(isPresented: $viewModel.exibindoFerramentas) {
                            ActionSheet(title: Text("Cria árvores vistas nos PDFs de aula."),
                                        message: nil,
                                        buttons: [.default(Text("+ Rot Simples à Direita - AVL pg 12")) { viewModel.inserirExemploRotacaoSimplesADireita() },
                                                  .default(Text("+ Rot Simples à Direita - AVL pg 14")) { viewModel.inserirSegundoExemploRotacaoSimplesADireita() },
                                                  .default(Text("+ Rot Simples à Esquerda - AVL pg 16")) { viewModel.inserirExemploRotacaoSimplesAEsquerda() },
                                                  .default(Text("+ Rot Simples à Esquerda - AVL pg 17")) { viewModel.inserirSegundoExemploRotacaoSimplesAEsquerda() },
                                                  .default(Text("+ Rot Dupla à Direita - AVL pg 19")) { viewModel.inserirExemploRotacaoDuplaADireita() },
                                                  .default(Text("+ Rot Dupla à Direita - AVL pg 22")) { viewModel.inserirSegundoExemploRotacaoDuplaADireita() },
                                                  .default(Text("Exclusão - AVL pg 30")) { viewModel.inserirExemploExclusao() },
                                                  .cancel(Text("Cancelar"))])
                        }
                    }
                    .padding(.trailing, 20)
                }
                
                Spacer()
                
                if viewModel.mostarArvore {
                    DiagramaSubarvore(no: viewModel.raiz)
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
                                viewModel.limparTextoInformativo()
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
                                viewModel.limparTextoInformativo()
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
                                viewModel.limparTextoInformativo()
                                viewModel.remover(Int(self.entrada)!)
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
                                                  .default(Text("🔢  Em Ordem")) { viewModel.exibirCaminhamentoEmOrdem() },
                                                  .default(Text("↪️  Pós-Ordem")) { viewModel.exibirCaminhamentoPosOrdem() },
                                                  .cancel(Text("Cancelar"))])
                        }
                        
                        Toggle(isOn: $viewModel.mostarArvore) {
                            Text("Mostar árvore")
                        }
                        .frame(width: 170)
                        .padding(.leading, 10)
                        
                        // LIMPAR ÁRVORE
                        Button(action: {
                            viewModel.limparArvore()
                        }) {
                            HStack {
                                Image(systemName: "tornado")
                            }
                        }
                        .buttonStyle(EstiloBordaComContorno())
                        .foregroundColor(.red)
                        .padding(.leading, 30)
                        .disabled(viewModel.arvoreVazia)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            
            Text(viewModel.status)
                .offset(y: 270)
        }
    }
}

struct TelaPrincipal_Previews: PreviewProvider {
    static var previews: some View {
        TelaPrincipal(viewModel: TelaPrincipalViewModel())
    }
}
