//
//  ArvoreAVLApp.swift
//  ArvoreAVL
//
//  Created by Rafael Schmitt on 17/09/20.
//

import SwiftUI

@main
struct ArvoreAVLApp: App {
    var body: some Scene {
        WindowGroup {
            ViewPrincipal(viewModel: ViewPrincipalViewModel())
        }
    }
}
