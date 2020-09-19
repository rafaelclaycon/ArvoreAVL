//
//  NoView.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 17/09/20.
//

import SwiftUI

struct NoView: View {
    @State var valor: Int?
    
    var body: some View {
        if valor != nil {
            ZStack {
                Circle()
                    .strokeBorder(Color.black, lineWidth: 1)
                    //.background(Circle().foregroundColor(Color.azulClaro))
                    .frame(width: 50, height: 50, alignment: .center)
                
                Text(String(self.valor!))
                    .font(.body)
            }
        } else {
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.gray)
                .frame(width: 50, height: 50, alignment: .center)
        }
    }
}

struct NoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NoView(valor: nil)
            NoView(valor: 1)
            NoView(valor: 10)
            NoView(valor: 999)
        }
        .previewLayout(.fixed(width: 80, height: 80))
    }
}
