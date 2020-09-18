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
    
    init(pai: No?, esquerda: No?, direita: No?, valor: Int, fatorBalanceamento: Int) {
        self.pai = pai
        self.esquerda = esquerda
        self.direita = direita
        self.valor = valor
        self.fatorBalanceamento = fatorBalanceamento
    }
}
