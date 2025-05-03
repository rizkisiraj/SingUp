//
//  VocalResult.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI

struct VocalResult: View {
    @Binding public var path : NavigationPath
    
    var body: some View {
        Text("Amazing !! \nYou Are")
            .multilineTextAlignment(.center)
            .font(.title)
            .padding()
        
        Image(systemName : "microphone.circle.fill")
            .font(.system(size : 150))
        
        Text("Tenor")
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .bold(true)
            .padding(.bottom , 50)
        
        Button(action: {
            path = NavigationPath()
        }) {
            Text("Finish")
                .foregroundColor(.white)
                .padding()
                .bold(true)
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
        }
        
    }
}


#Preview {
    @Previewable @State var path = NavigationPath()
    //VocalResult(path : $path)
    ContentView()
}
