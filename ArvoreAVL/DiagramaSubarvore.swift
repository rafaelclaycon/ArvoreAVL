//
//  Arvore.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 18/09/20.
//

import SwiftUI

struct DiagramaSubarvore: View {
    let no: No?
    
    var body: some View {
        if no != nil {
            VStack(alignment: .center) {
                NoView(valor: no!.valor, fator: no!.fatorBalanceamento)
                HStack(alignment: .center, spacing: 10) {
                    //Spacer()
                    DiagramaSubarvore(no: no!.esquerda)
                    Spacer()
                    DiagramaSubarvore(no: no!.direita)
                    //Spacer()
                }
            }
        }
    }
}

struct Arvore_Previews: PreviewProvider {
    static var previews: some View {
        DiagramaSubarvore(no: No(pai: nil, esquerda: nil, direita: No(pai: nil, esquerda: nil, direita: nil, valor: 1), valor: 0))
    }
}
