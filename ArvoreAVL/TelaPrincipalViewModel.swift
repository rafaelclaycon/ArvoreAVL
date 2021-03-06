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
            exibirTextoInformativo("O número \(valor) foi inserido.")
            self.mostarArvore = false
        } else {
            if valor < raiz!.valor {
                if raiz?.esquerda == nil {
                    raiz?.esquerda = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                    exibirTextoInformativo("O número \(valor) foi inserido.")
                    self.mostarArvore = false
                } else {
                    inserirEmSubarvore((raiz?.esquerda)!, valor)
                }
            } else if valor > raiz!.valor {
                if raiz?.direita == nil {
                    raiz?.direita = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                    exibirTextoInformativo("O número \(valor) foi inserido.")
                    self.mostarArvore = false
                } else {
                    inserirEmSubarvore((raiz?.direita)!, valor)
                }
            } else {
                exibirTextoInformativo("O número \(valor) já existe na árvore.")
            }
        }
        verificarBalanceamento(raiz, balancear: true)
    }
    
    func inserirEmSubarvore(_ raiz: No, _ valor: Int) {
        if valor < raiz.valor {
            if raiz.esquerda == nil {
                raiz.esquerda = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                exibirTextoInformativo("O número \(valor) foi inserido.")
                self.mostarArvore = false
            } else {
                inserirEmSubarvore((raiz.esquerda)!, valor)
            }
        } else if valor > raiz.valor {
            if raiz.direita == nil {
                raiz.direita = No(pai: raiz, esquerda: nil, direita: nil, valor: valor)
                exibirTextoInformativo("O número \(valor) foi inserido.")
                self.mostarArvore = false
            } else {
                inserirEmSubarvore((raiz.direita)!, valor)
            }
        } else {
            exibirTextoInformativo("O número \(valor) já existe na árvore.")
        }
    }
    
    // MARK: - Balanceamento
    func verificarBalanceamento(_ no: No?, balancear: Bool) {
        guard let noAtual = no else {
            return
        }
        
        verificarBalanceamento(noAtual.esquerda, balancear: balancear)
        verificarBalanceamento(noAtual.direita, balancear: balancear)
        
        print("\(noAtual.valor) consultado para balanceamento. F: \(noAtual.fatorBalanceamento)")
        
        if (noAtual.fatorBalanceamento < -1) || (noAtual.fatorBalanceamento > 1) {
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

                    if balancear {
                        rotacaoSimplesADireita(noAtual)
                        adicionarAoTextoInformativo("Rotação Simples à Direita aplicada.")
                    } else {
                        exibirTextoInformativo("Executaria uma Rotação Simples à Direita no nó \(noAtual.valor).")
                    }
                } else if noAtual.esquerda!.fatorBalanceamento < 0 {
                    print("Rotação Dupla à Direita")
                    
                    if balancear {
                        rotacaoDuplaADireita(noAtual)
                        adicionarAoTextoInformativo("Rotação Dupla à Direita aplicada.")
                    } else {
                        exibirTextoInformativo("Executaria uma Rotação Dupla à Direita no nó \(noAtual.valor).")
                    }
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
                    print("Rotação Dupla à Esquerda")
                    
                    if balancear {
                        rotacaoDuplaAEsquerda(noAtual)
                        adicionarAoTextoInformativo("Rotação Dupla à Esquerda aplicada.")
                    } else {
                        exibirTextoInformativo("Executaria uma Rotação Dupla à Esquerda no nó \(noAtual.valor).")
                    }
                } else if noAtual.direita!.fatorBalanceamento < 0 {
                    print("Rotação Simples à Esquerda")
                    
                    if balancear {
                        rotacaoSimplesAEsquerda(noAtual)
                        adicionarAoTextoInformativo("Rotação Simples à Esquerda aplicada.")
                    } else {
                        exibirTextoInformativo("Executaria uma Rotação Simples à Esquerda no nó \(noAtual.valor).")
                    }
                }
            }
        }
    }
    
    func rotacaoSimplesAEsquerda(_ a: No) {
        // b - com certeza existe
        let b = a.direita!
        // c
        let c = b.direita
        // d
        let d = b.esquerda
        
        imprimirVariavelAuxiliar(a, "a")
        imprimirVariavelAuxiliar(b, "b")
        imprimirVariavelAuxiliar(c, "c")
        imprimirVariavelAuxiliar(d, "d")
        
        if a.isRaiz {
            self.raiz = b
        } else {
            switch a.orientacaoEmRelacaoAoPai {
            case .esquerda:
                a.pai!.esquerda = b
            default:
                a.pai!.direita = b
            }
        }
        
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
        
        imprimirVariavelAuxiliar(k2, "k2")
        imprimirVariavelAuxiliar(k1, "k1")
        imprimirVariavelAuxiliar(x, "x")
        imprimirVariavelAuxiliar(y, "y")
        imprimirVariavelAuxiliar(z, "z")
        
        if k2.isRaiz {
            self.raiz = k1
        } else {
            switch k2.orientacaoEmRelacaoAoPai {
            case .esquerda:
                k2.pai!.esquerda = k1
            default:
                k2.pai!.direita = k1
            }
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
    
    func rotacaoDuplaADireita(_ k3: No) {
        let k1 = k3.esquerda!
        let k2 = k1.direita!
        //let a = k1.esquerda
        let b = k2.esquerda
        let c = k2.direita
        //let d = k3.direita
        
        if k3.isRaiz {
            self.raiz = k2
        } else {
            switch k3.orientacaoEmRelacaoAoPai {
            case .esquerda:
                k3.pai!.esquerda = k2
            default:
                k3.pai!.direita = k2
            }
        }
        
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
    }
    
    func rotacaoDuplaAEsquerda(_ k1: No) {
        let k3 = k1.direita!
        let k2 = k3.esquerda!
        let a = k1.esquerda
        let b = k2.esquerda
        let c = k2.direita
        let d = k3.direita
        
        imprimirVariavelAuxiliar(k1, "k1")
        imprimirVariavelAuxiliar(k2, "k2")
        imprimirVariavelAuxiliar(k3, "k3")
        imprimirVariavelAuxiliar(a, "a")
        imprimirVariavelAuxiliar(b, "b")
        imprimirVariavelAuxiliar(c, "c")
        imprimirVariavelAuxiliar(d, "d")
        
        // Rotação direita
        k1.direita = k2
        k2.pai = k1
        
        k2.direita = k3
        k3.pai = k2
        
        k3.esquerda = c
        c?.pai = k3
        
        // Rotação esquerda
        switch k1.orientacaoEmRelacaoAoPai {
        case .esquerda:
            k1.pai?.esquerda = k2
        case .direita:
            k1.pai?.direita = k2
        case .nenhuma:
            self.raiz = k2
        }
        k2.pai = k1.pai
        
        k2.esquerda = k1
        k1.pai = k2
        
        k1.direita = b
        b?.pai = k1
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
            exibirTextoInformativo("💀  O número \(valor) foi removido.")
            
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
            exibirTextoInformativo("💀  O número \(valor) foi removido.")
            
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
            exibirTextoInformativo("💀  O número \(valor) foi removido.")
        }
        
        verificarBalanceamento(raiz, balancear: true)
        
        self.mostarArvore = false
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
    func imprimir(_ no: No?) {
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
        imprimir(no!.direita)
        imprimir(no!.esquerda)
    }
    
    func exibirTextoInformativo(_ texto: String) {
        self.status = texto
    }
    
    func adicionarAoTextoInformativo(_ texto: String) {
        self.status = self.status + " " + texto
    }
    
    func limparTextoInformativo() {
        self.status = ""
    }
    
    func limparArvore() {
        if raiz != nil {
            raiz = nil
        }
        self.status = ""
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
    
    func imprimirVariavelAuxiliar(_ variavel: No?, _ nome: String) {
        guard let variavel = variavel else {
            return print(nome + ": -")
        }
        print(nome + ": \(variavel.valor)")
    }
    
    func inserirExemploRotacaoSimplesAEsquerda() {
        self.inserir(120)
        self.inserir(100)
        self.inserir(130)
        self.inserir(80)
        self.inserir(110)
        self.inserir(150)
        self.mostarArvore = false
        self.mostarArvore = true
    }
    
    func inserirSegundoExemploRotacaoSimplesAEsquerda() {
        self.inserir(42)
        self.inserir(15)
        self.inserir(88)
        self.inserir(67)
        self.inserir(94)
        self.mostarArvore = false
        self.mostarArvore = true
    }
    
    func inserirExemploRotacaoDuplaADireita() {
        self.inserir(120)
        self.inserir(110)
        self.inserir(150)
        self.inserir(80)
        self.inserir(130)
        self.inserir(200)
        self.mostarArvore = false
        self.mostarArvore = true
    }
    
    func inserirSegundoExemploRotacaoDuplaADireita() {
        self.inserir(42)
        self.inserir(15)
        self.inserir(88)
        self.inserir(6)
        self.inserir(27)
        self.mostarArvore = false
        self.mostarArvore = true
    }
    
    func inserirExemploRotacaoDuplaAEsquerda() {
        self.inserir(120)
        self.inserir(100)
        self.inserir(130)
        self.inserir(80)
        self.inserir(110)
        self.inserir(200)
        self.mostarArvore = false
        self.mostarArvore = true
    }
    
    func inserirExemploExclusaoG4G() {
        self.inserir(50)
        self.inserir(30)
        self.inserir(70)
        self.inserir(20)
        self.inserir(40)
        self.inserir(60)
        self.inserir(80)
        exibirTextoInformativo("Remova os números 20, 30 e 50.")
        self.mostarArvore = false
        self.mostarArvore = true
    }
    
    func inserirExemploCaminhoArvBinarias() {
        self.inserir(4)
        self.inserir(2)
        self.inserir(6)
        self.inserir(1)
        self.inserir(3)
        self.inserir(5)
        self.inserir(7)
        exibirTextoInformativo("Mostre os caminhamentos.")
        self.mostarArvore = false
        self.mostarArvore = true
    }
    
    func inserirExemploRotacaoDuplaAEsquerdaG4G() {
        self.inserir(5)
        self.inserir(2)
        self.inserir(7)
        self.inserir(1)
        self.inserir(4)
        self.inserir(6)
        self.inserir(9)
        self.inserir(3)
        self.inserir(16)
        exibirTextoInformativo("Insira o número 15.")
        self.mostarArvore = false
        self.mostarArvore = true
    }
}
