//
//  VocalTest.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI
import SwiftData

var peakFreq =  0

struct VocalTest: View {
    @Binding public var path : NavigationPath
    @State private var Num = 0
    public var type =  0
    @StateObject var detector = FrequencyDetector()
    @State var key = 0
    @State var octave = 1
    @Environment(\.modelContext) private var context
    @Query var userProfile : [UserProfile]
    
    
    func getPeakFreqChord() -> String{
        print("\(peakFreq)  \(Int(detector.frequency)) \(type == 1 && Int(detector.frequency) > peakFreq) ")
        if type == 0 && Int(detector.frequency) < peakFreq && Int(detector.frequency) > 60 {
            peakFreq = Int(detector.frequency)
        }
        
        if type == 1 && Int(detector.frequency) > peakFreq{
            peakFreq = Int(detector.frequency)
        }
        return "\(chord[  getChordByFrequency(freq : peakFreq)[0]  ])\( getChordByFrequency(freq : peakFreq)[1] )";
    }
   
    var taskRepeater = TaskRepeater()
    
    func increment() {
        Num = (Num + 1) % ( chord.count - 1 )
    }
    
    func reScale(range : Int)-> Int{
        return (chord.count + Num + range  ) % chord.count;
    }
    
    func getChord() -> [Int]{
        return getChordByFrequency(freq: Int(peakFreq))
    }
    
    
    var body: some View {
        Text("Sing 'AHH' \n as \(type == 0 ? "Lowest" : "Highest") as u Can")
            .font(.title)
            .multilineTextAlignment(.center)
            .bold(true)
            .padding()
            .padding(.bottom, 100)
        
        
        Image(systemName: "arrowtriangle.down.fill")
            .foregroundStyle(.purple)
            .font(.title.bold())
            .frame(maxWidth : .infinity, alignment : .center)
        
//        Divider()
//            .padding(.horizontal, 20)
//        
        HStack(spacing : 0){
                Text("\(chord[ (chord.count + getChord()[0]-2) % chord.count ])\(getChord()[1])")
                    .font(.title2)
                    .padding()
                
                Text("\(chord[ (chord.count + getChord()[0]-1) % chord.count ])\(getChord()[1])")
                    .font(.title2)
                    .padding()
                

                Text("\(chord[getChord()[0]])\(getChord()[1])")
                .font(.largeTitle)
                    .bold(true)
                    .multilineTextAlignment(.center)
                    .padding()
                
                
                Text("\(chord[ (getChord()[0]+1) % chord.count ])\(getChord()[1])")
                    .font(.title2)
                    .padding()
                
                Text("\(chord[ (getChord()[0]+2) % chord.count ])\(getChord()[1])")
                    .font(.title2)
                    .padding()
                
            }
            .onAppear{
                key = getChordByFrequency(freq: Int(detector.frequency))[0]
                octave = getChordByFrequency(freq: Int(detector.frequency))[1]
                peakFreq = type == 0 ? 99999 : 0
                
            }
           
//        Divider()
//            .padding(.horizontal, 20)
        
        Text("\(peakFreq < 99999 ? peakFreq : 0) Hz")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
        Button(action : {}){
            Image(systemName: "arrowtriangle.down.circle.fill")
            Text("Go Lower")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray)
                .opacity(0.1)
        )
        HStack{
            Text("Your\(type == 0 ? " Lowest" : " Highest") chord is : ")
            Text("\(getPeakFreqChord())")
                .font(.title2.bold())
        }
       
        
        Button(
            action : {
                if let prof = userProfile.first{
                    if type == 0 {
                        prof.lowestFrequency = Float(peakFreq)
                    } else {
                        prof.highestFrequency = Float(peakFreq)
                    }
                    do{
                        try context.save()
                        print("Berhasil menyimpan hasil test")

                    }catch{
                        print("Gagal menyimpan hasil test \(error)")
                    }
                }
//                path.removeLast(1)
                path.append(type == 0 ? "vtest2" : "vocalresult")
            }
        ){
            Text("Continue")
                .foregroundStyle(.white)
        }
        .padding(15)
        .padding(.horizontal, 100)
        .background(
            RoundedRectangle(cornerRadius: 10).fill(Color.blue)
        )
        .padding(.top, 50)

        
    }
        
}

#Preview{
    @Previewable @State var path = NavigationPath()
    //ContentView()
    VocalTest(path : $path)
}
