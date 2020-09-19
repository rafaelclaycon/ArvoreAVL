//
//  No.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 17/09/20.
//

import Foundation

class No {
    var pai: No?
    var esquerda: No?
    var direita: No?
    var valor: Int
    var fatorBalanceamento: Int
    var isRaiz: Bool {
        return pai == nil
    }
    
    init(pai: No?, esquerda: No?, direita: No?, valor: Int) {
        self.pai = pai
        self.esquerda = esquerda
        self.direita = direita
        self.valor = valor
        self.fatorBalanceamento = No.getAltura(esquerda) - No.getAltura(direita)
    }
    
    static func getAltura(_ no: No?) -> Int {
        if no == nil {
            return 0
        } else {
            let alturaEsquerda = getAltura(no?.esquerda)
            let alturaDireita = getAltura(no?.direita)
            
            if alturaEsquerda > alturaDireita {
                return alturaEsquerda + 1
            } else {
                return alturaDireita + 1
            }
        }
    }
    
    func recalcularFatorBalanceamento() {
        self.fatorBalanceamento = No.getAltura(esquerda) - No.getAltura(direita)
    }
}
