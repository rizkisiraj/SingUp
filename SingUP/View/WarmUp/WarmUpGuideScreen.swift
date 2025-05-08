//
//  BreathingPage.swift
//  SingUP
//
//  Created by Rizki Siraj on 06/05/25.
//
import SwiftUI
import Foundation


struct WarmUpGuideScreen: View {
    var warmUp: WarmUp
    
    var body: some View {
        VStack {
            Spacer()
            Text(warmUp.title)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Image(warmUp.image)
            Spacer()
            Text(warmUp.description)
                .multilineTextAlignment(.center)
                
            Spacer()
            Button {
                
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
    NavigationStack{
        WarmUpGuideScreen(
            warmUp: listOfWarmUp[0]
        )
    }
}
