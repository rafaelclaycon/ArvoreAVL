//
//  NoView.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 17/09/20.
//

import SwiftUI

struct NoView: View {
    @State var valor: Int
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color(UIColor(red: 0.09, green: 0.43, blue: 0.78, alpha: 1.00)),lineWidth: 1)
                .background(Circle().foregroundColor(Color(UIColor(red: 0.70, green: 0.85, blue: 0.98, alpha: 1.00))))
                .frame(width: 50, height: 50, alignment: .center)
            
            Text(String(self.valor))
                .font(.body)
        }
    }
}

struct NoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NoView(valor: 1)
            NoView(valor: 10)
            NoView(valor: 999)
        }
        .previewLayout(.fixed(width: 80, height: 80))
    }
}
