//
//  Arvore.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 18/09/20.
//

import SwiftUI

struct DiagramaArvore: View {
    let no: No?
    
    var body: some View {
        if no != nil {
            VStack(alignment: .center) {
                NoView(valor: no!.valor)
                HStack(alignment: .bottom, spacing: 10) {
                    //Spacer()
                    DiagramaArvore(no: no!.esquerda)
                    Spacer()
                    DiagramaArvore(no: no!.direita)
                    //Spacer()
                }
            }
        }
    }
}

struct Arvore_Previews: PreviewProvider {
    static var previews: some View {
        DiagramaArvore(no: No(pai: nil, esquerda: nil, direita: No(pai: nil, esquerda: nil, direita: nil, valor: 1), valor: 0))
    }
}
