//
//  ArvoreViewViewModel.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 17/09/20.
//

import Combine
import SwiftUI

class ViewPrincipalViewModel: ObservableObject {
    @Published var raiz: No? = nil
    @Published var imagemPerfil: Image = ImageStore.shared.image(name: "imagem_perfil")
    @Published var mostarFatorBalanceamento: Bool = true
    @Published var status: String = ""
    
    func inserir(_ valor: Int) {
        if raiz == nil {
            raiz = No(pai: nil, esquerda: nil, direita: nil, valor: valor)
        } else {
            if valor < raiz!.valor {
                if raiz?.esquerda == nil {
                    objectWillChange.send()
                    raiz?.esquerda = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                } else {
                    objectWillChange.send()
                    inserirEmSubarvore((raiz?.esquerda)!, valor)
                }
                raiz?.recalcularFatorBalanceamento()
            } else if valor > raiz!.valor {
                if raiz?.direita == nil {
                    objectWillChange.send()
                    raiz?.direita = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                } else {
                    objectWillChange.send()
                    inserirEmSubarvore((raiz?.direita)!, valor)
                }
                raiz?.recalcularFatorBalanceamento()
            } else {
                self.status = "O número \(valor) já existe na árvore."
            }
        }
        
        print(" ")
        print("----------------")
        verificaBalanceamento(raiz)
        imprime(raiz)
    }
    
    func inserirEmSubarvore(_ raiz: No, _ valor: Int) {
        if valor < raiz.valor {
            if raiz.esquerda == nil {
                raiz.esquerda = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
            } else {
                inserirEmSubarvore((raiz.esquerda)!, valor)
            }
            raiz.recalcularFatorBalanceamento()
        } else if valor > raiz.valor {
            if raiz.direita == nil {
                raiz.direita = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
            } else {
                inserirEmSubarvore((raiz.direita)!, valor)
            }
            raiz.recalcularFatorBalanceamento()
        } else {
            self.status = "O número \(valor) já existe na árvore."
        }
    }
    
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
    
    func verificaBalanceamento(_ no: No?) {
        if no == nil {
            return
        }
        
        if (no!.fatorBalanceamento < -1) || (no!.fatorBalanceamento > 1) {
            print("Nó \(no!.valor) necessita balanceamento! F: \(no!.fatorBalanceamento)")
        }
        
        verificaBalanceamento(no!.direita)
        verificaBalanceamento(no!.esquerda)
    }
    
    func rotacaoSimplesAEsquerda() {
        
    }
    
    func rotacaoSimplesADireita() {
        
    }
}
