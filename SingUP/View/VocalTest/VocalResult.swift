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
    
    func getRange(idx : Int)->Bool{
        //vocalRange.getVocalTypeIndex(lowFreq: freq[0], highFreq: freq[1])
        let vocalIdx = vocalRange.getVocalTypeIndex(lowFreq: freq[0], highFreq: freq[1]) * 4
        if (24 - idx ) <= vocalIdx + 4 && (24 - idx ) > vocalIdx {
            return true;
        }
        return false
    }

    var body: some View {
        Text("Your vocal range is : ")
            .multilineTextAlignment(.center)
            .font(.title)
            .padding(5)
        
        Text(vocalRange.getVocalType(lowFreq: freq[0], highFreq: freq[1]))
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .bold(true)
                
        HStack(spacing : 0){
            VStack(spacing : 20){
                ForEach(Array(vocalRange.range.reversed().enumerated()), id: \.offset) { index, item in
                    Text(item)
                        .foregroundStyle(( ((vocalRange.range.count - 1) - index ) == vocalRange.getVocalTypeIndex(lowFreq: freq[0], highFreq: freq[1]) ) ? .blue : .gray )
                }
            }
            
            VStack(spacing : 5){
                Text("Highest")
                    .font(.title3.bold())
                    .padding(.vertical, 20)

                ForEach(0..<24){ index in
                    RoundedRectangle(cornerRadius: 20)
                        .fill( getRange(idx : index) ? .blue : .gray)
                        .frame(maxWidth : 30, maxHeight: 5)
                }
               
                Text("Lowest")
                    .font(.title3.bold())
                    .padding(.vertical, 20)
            }
        }
        .padding(.trailing, 60)

        
        
//        Text(vocalRange.getVocalType(lowFreq: freq[0], highFreq: freq[1]))
//            .multilineTextAlignment(.center)
//            .font(.largeTitle)
//            .bold(true)
//            .padding(.bottom , 50)
//        
        Button(action: {
            path = NavigationPath()
        }) {
            Text("Finish")
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
