//
//  EstiloBordaComContorno.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 17/09/20.
//

import SwiftUI

struct EstiloBordaComContorno: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 1.0)
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}
