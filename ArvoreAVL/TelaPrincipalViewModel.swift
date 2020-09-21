//
//  ArvoreViewViewModel.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 17/09/20.
//

import Combine
import SwiftUI

class TelaPrincipalViewModel: ObservableObject {
    @Published var raiz: No? = nil
    @Published var imagemPerfil: Image = ImageStore.shared.image(name: "imagem_perfil")
    @Published var mostarFatorBalanceamento: Bool = true
    @Published var status: String = ""
    @Published var mostarTextoInformativo: Bool = false
    
    // Variáveis privadas
    var nosConsultados = [String]()
    
    // MARK: - Inserção
    func inserir(_ valor: Int) {
        if raiz == nil {
            raiz = No(pai: nil, esquerda: nil, direita: nil, valor: valor)
        } else {
            if valor < raiz!.valor {
                if raiz?.esquerda == nil {
                    raiz?.esquerda = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                } else {
                    inserirEmSubarvore((raiz?.esquerda)!, valor)
                }
            } else if valor > raiz!.valor {
                if raiz?.direita == nil {
                    raiz?.direita = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                } else {
                    inserirEmSubarvore((raiz?.direita)!, valor)
                }
            } else {
                exibirTextoInformativo("O número \(valor) já existe na árvore.")
            }
        }
        
        print(" ")
        print("----------------")
        verificaBalanceamento(raiz)
        print(" ")
        imprime(raiz)
    }
    
    func inserirEmSubarvore(_ raiz: No, _ valor: Int) {
        if valor < raiz.valor {
            if raiz.esquerda == nil {
                raiz.esquerda = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
            } else {
                inserirEmSubarvore((raiz.esquerda)!, valor)
            }
        } else if valor > raiz.valor {
            if raiz.direita == nil {
                raiz.direita = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
            } else {
                inserirEmSubarvore((raiz.direita)!, valor)
            }
        } else {
            exibirTextoInformativo("O número \(valor) já existe na árvore.")
        }
    }
    
    // MARK: - Balanceamento
    func verificaBalanceamento(_ no: No?) {
        if no == nil {
            return
        }
        
        if (no!.fatorBalanceamento < -1) || (no!.fatorBalanceamento > 1) {
            //self.status = "Nó \(no!.valor) necessita balanceamento!"
            print("Nó \(no!.valor) necessita balanceamento!")
            
            // Rotação Simples à Direita
            // Toda vez que uma sub-árvore fica com um fator
            // POSITIVO e sua sub-árvore da esquerda também tem um fator POSITIVO
            
            // Rotação Dupla à Direita
            // Toda vez que uma sub-árvore fica com um fator
            // POSITIVO e sua sub-árvore da esquerda também tem um fator NEGATIVO
            
            if no!.fatorBalanceamento > 1 {
                if no!.esquerda!.fatorBalanceamento > 0 {
                    exibirTextoInformativo("Rotação Simples à Direita aplicada.")
                    
                    print("Rotação Simples à Direita")
                    if no!.isRaiz {
                        self.raiz = no!.esquerda
                    }
                    rotacaoSimplesADireita(no!)
                    return
                } else if no!.esquerda!.fatorBalanceamento < 0 {
                    exibirTextoInformativo("Rotação Dupla à Direita aplicada.")
                    
                    print("Rotação Dupla à Direita")
                    if no!.isRaiz {
                        self.raiz = no!.esquerda!.direita
                    }
                    rotacaoDuplaADireita(no!, pai: no!.pai)
                    return
                }
            }
            
            // Rotação Simples à Esquerda
            // Toda vez que uma sub-árvore fica com um fator
            // NEGATIVO e sua sub-árvore da direita também tem um fator NEGATIVO
            
            // Rotação Dupla à Esquerda
            // Toda vez que uma sub-árvore fica com um fator
            // NEGATIVO e sua sub-árvore da direita também tem um fator POSITIVO
            
            if no!.fatorBalanceamento < -1 {
                if no!.direita!.fatorBalanceamento > 0 {
                    exibirTextoInformativo("Rotação Dupla à Esquerda aplicada.")
                    print("Rotação Dupla à Esquerda")
                    
                } else if no!.direita!.fatorBalanceamento < 0 {
                    exibirTextoInformativo("Rotação Simples à Esquerda aplicada.")
                    
                    print("Rotação Simples à Esquerda")
                    if no!.isRaiz {
                        self.raiz = no!.direita
                    }
                    rotacaoSimplesAEsquerda(no!)
                    return
                }
            }
        }
        
        verificaBalanceamento(no!.direita)
        verificaBalanceamento(no!.esquerda)
    }
    
    func rotacaoSimplesAEsquerda(_ a: No) {
        // b - com certeza existe
        let b = a.direita!
        // c
        //let c = b.direita
        // d
        let d = b.esquerda
        
        b.pai = a.pai
        a.pai = b
        
        a.direita = d
        b.esquerda = a
    }
    
    func rotacaoSimplesADireita(_ k2: No) {
        // k1 - com certeza existe
        let k1 = k2.esquerda!
        // x
        //let x = k1.esquerda
        // y
        let y = k1.direita
        // z
        let z = k2.direita
        
        k1.pai = k2.pai
        k2.pai = k1
        
        //k1.esquerda = x
        k1.direita = k2
        
        k2.esquerda = y
        k2.direita = z
        
        y?.pai = k2
        z?.pai = k2
    }
    
    func rotacaoDuplaADireita(_ k3: No, pai: No?) {
        let k1 = k3.esquerda!
        let k2 = k1.direita!
        //let a = k1.esquerda
        let b = k2.esquerda
        let c = k2.direita
        //let d = k3.direita
        
        // Rotação esquerda
        k3.esquerda = k2
        
        k2.pai = k3
        k2.esquerda = k1
        
        k1.pai = k2
        k1.direita = b
        
        // Rotação direita
        k2.pai = k3.pai
        k2.direita = k3
        
        k3.pai = k2
        k3.esquerda = c
        
        if pai != nil {
            pai!.esquerda = k2
        }
    }
    
    // MARK: - Busca
    func buscar(valor: Int) {
        if raiz == nil {
            exibirTextoInformativo("☹️  O número consultado não está na árvore pois a árvore está vazia.")
        } else {
            self.nosConsultados.append("\(raiz!.valor)")
            
            if valor == raiz!.valor {
                exibirTextoInformativo("🎉  O número \(valor) está na árvore. Nós consultados: " + self.nosConsultados.joined(separator: ", "))
            } else {
                var no: No?
                if valor < raiz!.valor {
                    no = raiz!.esquerda
                } else {
                    no = raiz!.direita
                }
                
                let encontrado = buscarNaSubarvore(valor, no)
                
                if encontrado {
                    exibirTextoInformativo("🎉  O número \(valor) está na árvore. Nós consultados: " + self.nosConsultados.joined(separator: ", "))
                } else {
                    exibirTextoInformativo("☹️  O número \(valor) não está na árvore. Nós consultados: " + self.nosConsultados.joined(separator: ", "))
                }
            }
            // Limpa o array que guarda o caminho percorrido pela pesquisa.
            self.nosConsultados.removeAll()
        }
    }
    
    func buscarNaSubarvore(_ valor: Int, _ no: No?) -> Bool {
        guard let no = no else {
            return false
        }
        
        self.nosConsultados.append("\(no.valor)")
        
        if valor < no.valor {
            return buscarNaSubarvore(valor, no.esquerda)
        } else if valor > no.valor {
            return buscarNaSubarvore(valor, no.direita)
        }
        return true
    }
    
    // MARK: - Funções auxiliares
    func imprime(_ no: No?) {
        if no == nil {
            return
        }
        
        var valorPai = " "
        if no!.pai != nil {
            valorPai = "\(no!.pai!.valor)"
        }
        
        var valorEsquerda = " "
        if no!.esquerda != nil {
            valorEsquerda = "\(no!.esquerda!.valor)"
        }
        
        var valorDireita = " "
        if no!.direita != nil {
            valorDireita = "\(no!.direita!.valor)"
        }
        
        print("(\(no!.valor)) - ^: \(valorPai), E: \(valorEsquerda), D: \(valorDireita), F: \(no!.fatorBalanceamento)")
        imprime(no!.direita)
        imprime(no!.esquerda)
    }
    
    func exibirTextoInformativo(_ texto: String) {
        self.status = texto
        
        self.mostarTextoInformativo = true
        
        _ = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { timer in
            DispatchQueue.main.async {
                self.mostarTextoInformativo = false
            }
        }
    }
}
