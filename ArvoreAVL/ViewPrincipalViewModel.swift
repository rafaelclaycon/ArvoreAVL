//
//  ArvoreViewViewModel.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 17/09/20.
//

import Combine
import SwiftUI

class ViewPrincipalViewModel: ObservableObject {
    var arvore: [No]? = nil
    
    func inserir(_ valor: Int) {
        if arvore == nil {
            arvore?.append(No(pai: nil, esquerda: nil, direita: nil, valor: valor, fatorBalanceamento: 0))
        }
    }
}
