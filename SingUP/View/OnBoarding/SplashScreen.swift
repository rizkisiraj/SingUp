//
//  SplashScreen.swift
//  SingUP
//
//  Created by Surya on 11/05/25.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Image("SingUpIcon")
            }
        }
        .preferredColorScheme(.light) // <- Force light mode
    }
}

#Preview {
    SplashScreen()
}
