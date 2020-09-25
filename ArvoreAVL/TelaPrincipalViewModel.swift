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
    @Published var mostarArvore: Bool = true
    @Published var status: String = ""
    @Published var mostarTextoInformativo: Bool = false
    @Published var exibindoOpcoesCaminhamento = false
    @Published var exibindoFerramentas = false
    
    var arvoreVazia: Bool {
        return raiz == nil
    }
    private var nosConsultados = [String]()
    private var caminhamento = [String]()
    
    // MARK: - Inserção
    func inserir(_ valor: Int) {
        if raiz == nil {
            raiz = No(pai: nil, esquerda: nil, direita: nil, valor: valor)
        } else {
            if valor < raiz!.valor {
                if raiz?.esquerda == nil {
                    raiz?.esquerda = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                    exibirTextoInformativo("O número \(valor) foi inserido.")
                } else {
                    inserirEmSubarvore((raiz?.esquerda)!, valor)
                }
            } else if valor > raiz!.valor {
                if raiz?.direita == nil {
                    raiz?.direita = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                    exibirTextoInformativo("O número \(valor) foi inserido.")
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
        
        self.mostarArvore = false
    }
    
    func inserirEmSubarvore(_ raiz: No, _ valor: Int) {
        if valor < raiz.valor {
            if raiz.esquerda == nil {
                raiz.esquerda = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                exibirTextoInformativo("O número \(valor) foi inserido.")
            } else {
                inserirEmSubarvore((raiz.esquerda)!, valor)
            }
        } else if valor > raiz.valor {
            if raiz.direita == nil {
                raiz.direita = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                exibirTextoInformativo("O número \(valor) foi inserido.")
            } else {
                inserirEmSubarvore((raiz.direita)!, valor)
            }
        } else {
            exibirTextoInformativo("O número \(valor) já existe na árvore.")
        }
    }
    
    // MARK: - Balanceamento
    func verificaBalanceamento(_ no: No?) {
        guard let noAtual = no else {
            return
        }
        
        if (noAtual.fatorBalanceamento < -1) || (noAtual.fatorBalanceamento > 1) {
            //self.status = "Nó \(no!.valor) necessita balanceamento!"
            print("Nó \(noAtual.valor) necessita balanceamento!")
            
            // Rotação Simples à Direita
            // Toda vez que uma sub-árvore fica com um fator
            // POSITIVO e sua sub-árvore da esquerda também tem um fator POSITIVO
            
            // Rotação Dupla à Direita
            // Toda vez que uma sub-árvore fica com um fator
            // POSITIVO e sua sub-árvore da esquerda também tem um fator NEGATIVO
            
            if noAtual.fatorBalanceamento > 1 {
                if noAtual.esquerda!.fatorBalanceamento > 0 {
                    print("Rotação Simples à Direita")

                    rotacaoSimplesADireita(noAtual)
                    
                    adicionarAoTextoInformativo("Rotação Simples à Direita aplicada.")
                    return
                } else if noAtual.esquerda!.fatorBalanceamento < 0 {
                    exibirTextoInformativo("Rotação Dupla à Direita aplicada.")
                    
                    print("Rotação Dupla à Direita")
                    if noAtual.isRaiz {
                        self.raiz = noAtual.esquerda!.direita
                    }
                    rotacaoDuplaADireita(noAtual, pai: noAtual.pai)
                    return
                }
            }
            
            // Rotação Simples à Esquerda
            // Toda vez que uma sub-árvore fica com um fator
            // NEGATIVO e sua sub-árvore da direita também tem um fator NEGATIVO
            
            // Rotação Dupla à Esquerda
            // Toda vez que uma sub-árvore fica com um fator
            // NEGATIVO e sua sub-árvore da direita também tem um fator POSITIVO
            
            if noAtual.fatorBalanceamento < -1 {
                if noAtual.direita!.fatorBalanceamento > 0 {
                    exibirTextoInformativo("Rotação Dupla à Esquerda aplicada.")
                    print("Rotação Dupla à Esquerda")
                    
                } else if noAtual.direita!.fatorBalanceamento < 0 {
                    exibirTextoInformativo("Rotação Simples à Esquerda aplicada.")
                    
                    print("Rotação Simples à Esquerda")
                    if noAtual.isRaiz {
                        self.raiz = noAtual.direita
                    }
                    rotacaoSimplesAEsquerda(noAtual)
                    return
                }
            }
        }
        
        verificaBalanceamento(noAtual.direita)
        verificaBalanceamento(noAtual.esquerda)
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
        let x = k1.esquerda
        // y
        let y = k1.direita
        // z
        let z = k2.direita
        
        imprimeVariavelAuxiliar(k2, "k2")
        imprimeVariavelAuxiliar(k1, "k1")
        imprimeVariavelAuxiliar(x, "x")
        imprimeVariavelAuxiliar(y, "y")
        imprimeVariavelAuxiliar(z, "z")
        
        if k2.isRaiz {
            self.raiz = k1
        } else {
            k2.pai!.esquerda = k1
        }
        
        k1.pai = k2.pai
        k2.pai = k1
        
        k1.esquerda = x
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
    
    func rotacaoDuplaAEsquerda() {
        
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
    
    // MARK: - Remoção
    func remover(_ valor: Int) {
        guard let noASerRemovido = getNo(comValor: valor, aPartirDe: raiz) else {
            return exibirTextoInformativo("⛔️  Não é possível remover o número \(valor) pois ele não está na árvore.")
        }
        
        // Caso 1: O nó a ser removido é um nó folha.
        if (noASerRemovido.esquerda == nil) && (noASerRemovido.direita == nil) {
            if noASerRemovido.valor == raiz?.valor {
                raiz = nil
            } else {
                switch noASerRemovido.orientacaoEmRelacaoAoPai {
                case .esquerda:
                    noASerRemovido.pai?.esquerda = nil
                default:
                    noASerRemovido.pai?.direita = nil
                }
            }
            
        // Caso 2: O nó a ser removido só tem 1 filho.
        } else if (noASerRemovido.esquerda == nil) || (noASerRemovido.direita == nil) {
            var filho: No? = nil
            if noASerRemovido.esquerda != nil {
                filho = noASerRemovido.esquerda!
            } else if noASerRemovido.direita != nil {
                filho = noASerRemovido.direita!
            }
            
            if noASerRemovido.valor == raiz?.valor {
                raiz = filho
                filho!.pai = nil
            } else {
                switch noASerRemovido.orientacaoEmRelacaoAoPai {
                case .esquerda:
                    noASerRemovido.pai?.esquerda = filho
                default:
                    noASerRemovido.pai?.direita = filho
                }
                filho!.pai = noASerRemovido.pai
            }
            
        // Caso 3: O nó a ser removido tem 2 filhos.
        } else if (noASerRemovido.esquerda != nil) && (noASerRemovido.direita != nil) {
            let sucessorEmOrdem = getMenorADireita(noASerRemovido.direita!)
            remover(sucessorEmOrdem.valor)
            
            sucessorEmOrdem.pai = noASerRemovido.pai
            sucessorEmOrdem.esquerda = noASerRemovido.esquerda
            sucessorEmOrdem.direita = noASerRemovido.direita
            
            if noASerRemovido.valor == raiz?.valor {
                raiz = sucessorEmOrdem
            } else {
                switch noASerRemovido.orientacaoEmRelacaoAoPai {
                case .esquerda:
                    noASerRemovido.pai?.esquerda = sucessorEmOrdem
                default:
                    noASerRemovido.pai?.direita = sucessorEmOrdem
                }
            }
        }
        
        verificaBalanceamento(noASerRemovido.pai)
    }
    
    func getNo(comValor valor: Int, aPartirDe no: No?) -> No? {
        guard let no = no else {
            return nil
        }
                
        if valor < no.valor {
            return getNo(comValor: valor, aPartirDe: no.esquerda)
        } else if valor > no.valor {
            return getNo(comValor: valor, aPartirDe: no.direita)
        }
        return no
    }
    
    func getMenorADireita(_ no: No) -> No {
        var atual = no
        while (atual.esquerda != nil) {
            atual = atual.esquerda!
        }
        return atual
    }
    
    // MARK: - Caminhamento
    
    func exibirCaminhamentoPreOrdem() {
        guard let raiz = raiz else {
            return exibirTextoInformativo("Não é possível exibir o caminhamento pois a árvore está vazia.")
        }
        if !self.caminhamento.isEmpty {
            self.caminhamento.removeAll()
        }
        subarvorePreOrdem(raiz)
        exibirTextoInformativo("🥾  Caminhamento em Pré-Ordem: " + self.caminhamento.joined(separator: ", "))
    }
    
    func exibirCaminhamentoPosOrdem() {
        guard let raiz = raiz else {
            return exibirTextoInformativo("Não é possível exibir o caminhamento pois a árvore está vazia.")
        }
        if !self.caminhamento.isEmpty {
            self.caminhamento.removeAll()
        }
        subarvorePosOrdem(raiz)
        exibirTextoInformativo("🥾  Caminhamento em Pós-Ordem: " + self.caminhamento.joined(separator: ", "))
    }
    
    func exibirCaminhamentoEmOrdem() {
        guard let raiz = raiz else {
            return exibirTextoInformativo("Não é possível exibir o caminhamento pois a árvore está vazia.")
        }
        if !self.caminhamento.isEmpty {
            self.caminhamento.removeAll()
        }
        subarvoreEmOrdem(raiz)
        exibirTextoInformativo("🥾  Caminhamento Em Ordem: " + self.caminhamento.joined(separator: ", "))
    }
    
    func subarvorePreOrdem(_ no: No?) {
        guard let no = no else {
            return
        }
        caminhamento.append("\(no.valor)")
        subarvorePreOrdem(no.esquerda)
        subarvorePreOrdem(no.direita)
    }
    
    func subarvorePosOrdem(_ no: No?) {
        guard let no = no else {
            return
        }
        subarvorePosOrdem(no.esquerda)
        subarvorePosOrdem(no.direita)
        caminhamento.append("\(no.valor)")
    }
    
    func subarvoreEmOrdem(_ no: No?) {
        guard let no = no else {
            return
        }
        subarvoreEmOrdem(no.esquerda)
        caminhamento.append("\(no.valor)")
        subarvoreEmOrdem(no.direita)
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
        
//        _ = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { timer in
//            DispatchQueue.main.async {
//                self.mostarTextoInformativo = false
//            }
//        }
    }
    
    func adicionarAoTextoInformativo(_ texto: String) {
        self.status = self.status + " " + texto
    }
    
    func limparArvore() {
        if raiz != nil {
            raiz = nil
        }
    }
    
    func inserirExemploExclusao() {
        self.inserir(32)
        self.inserir(16)
        self.inserir(48)
        self.inserir(8)
        self.inserir(24)
        self.inserir(40)
        self.inserir(56)
        self.inserir(28)
        self.inserir(36)
        self.inserir(44)
        self.inserir(52)
        self.inserir(60)
        self.inserir(58)
        self.inserir(62)
        self.mostarArvore = false
        self.mostarArvore = true
    }
    
    func inserirExemploRotacaoSimplesADireita() {
        self.inserir(120)
        self.inserir(110)
        self.inserir(150)
        self.inserir(100)
        self.inserir(130)
        self.inserir(200)
        self.mostarArvore = false
        self.mostarArvore = true
    }
    
    func inserirSegundoExemploRotacaoSimplesADireita() {
        self.inserir(42)
        self.inserir(15)
        self.inserir(88)
        self.inserir(6)
        self.inserir(27)
        self.mostarArvore = false
        self.mostarArvore = true
    }
    
    func imprimeVariavelAuxiliar(_ variavel: No?, _ nome: String) {
        guard let variavel = variavel else {
            return print(nome + ": -")
        }
        print(nome + ": \(variavel.valor)")
    }
}
