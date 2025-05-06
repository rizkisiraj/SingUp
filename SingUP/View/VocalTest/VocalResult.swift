//
//  VocalResult.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI
import SwiftData

struct VocalResult: View {
    @Binding public var path : NavigationPath
    @State var freq : [Int] = [0, 9999]
    var vocalRange = VocalRange()
    @Environment(\.modelContext) var context
    @Query var userProfile : [UserProfile]

    var body: some View {
        Text("Amazing !! \nYou Are")
            .multilineTextAlignment(.center)
            .font(.title)
            .padding()
        
        Image(systemName : "microphone.circle.fill")
            .font(.system(size : 150))
        
        Text(vocalRange.getVocalType(lowFreq: freq[0], highFreq: freq[1]))
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
        .onAppear{
            if let prof = userProfile.first{
                freq = [Int(prof.lowestFrequency), Int(prof.highestFrequency)]
            }
        }
        
    }
}


#Preview {
    @Previewable @State var path = NavigationPath()
    //VocalResult(path : $path)
    ContentView()
}
