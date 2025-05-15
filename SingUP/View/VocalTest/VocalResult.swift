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
    @Environment(\.modelContext) var context
    @Query var userProfile : [UserProfile]
    var vocalR = VocalRange()
    
    func getRange(idx : Int)->Bool{
        //vocalRange.getVocalTypeIndex(lowFreq: freq[0], highFreq: freq[1])
        let vocalIdx = vocalR.getVocalTypeIndex(lowFreq: freq[0], highFreq: freq[1]) * 4
        if (24 - idx ) <= vocalIdx + 4 && (24 - idx ) > vocalIdx {
            return true;
        }
        return false
    }

    var body: some View {
        Text("AMAZING!")
            .multilineTextAlignment(.center)
            .font(.largeTitle.bold())
        
        Text("You are a")
            .multilineTextAlignment(.center)
            .font(.title.bold())
            .foregroundStyle(.gray)
        
      
        Image(vocalR.getVocalType(lowFreq: freq[0], highFreq: freq[1]))
            .resizable()
            .frame(width: 230, height: 230)
            .padding(0)
        
        Text(vocalR.getVocalType(lowFreq: freq[0], highFreq: freq[1]).uppercased())
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .bold(true)
        
        Text("\(getChordString(frequency : freq[0])) - \(getChordString(frequency : freq[1]))")
              .multilineTextAlignment(.center)
              .font(.title2)
              .bold(true)
              .padding(.bottom, 20)
        
        
        Text(vocalRange[vocalR.getVocalType(lowFreq: freq[0], highFreq: freq[1]).lowercased()] ?? "bass")
            .multilineTextAlignment(.center)
            .frame(maxWidth : .infinity)
            .font(.headline)
            .padding(.horizontal, 50)
            .padding(.bottom, 20)
//
        Button(action: {
            path = NavigationPath()
        }) {
            Text("Done")
                .padding()
                .frame(maxWidth : .infinity)
                .foregroundColor(.white)
                .bold(true)
                .background(Color.blue)
                .cornerRadius(10)
            
        }
        .padding(.horizontal, 50)
        .onAppear{
            if let prof = userProfile.first{
                freq = [Int(prof.lowestFrequency), Int(prof.highestFrequency)]
            }
        }
        
    }
}


#Preview {
    @Previewable @State var path = NavigationPath()
    VocalResult(path : $path)
    //ContentView()
}
