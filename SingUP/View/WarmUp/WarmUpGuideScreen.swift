//
//  BreathingPage.swift
//  SingUP
//
//  Created by Rizki Siraj on 06/05/25.
//
import SwiftUI
import Foundation
import Lottie

struct WarmUpGuideScreen: View {
    var warmUp: WarmUp
    @Binding var path : NavigationPath
    
    var body: some View {
        VStack {
            Spacer()
            Text(warmUp.title)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            LottieView(animation: .named(warmUp.title))
                .looping()
            Spacer()
            Text(warmUp.description)
                .multilineTextAlignment(.center)
                
            Spacer()
            Button {
                warmup = warmUp
                path.append(warmUp.path)
            } label: {
                Text("Start")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            Spacer()
        }
        .padding()
    }
}

#Preview{
    @Previewable @State var path = NavigationPath()

    NavigationStack{
        WarmUpGuideScreen(
            warmUp: listOfWarmUp[0],
            path : $path
        )
    }
}
