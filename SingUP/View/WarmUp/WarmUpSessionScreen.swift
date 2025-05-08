//
//  WarmUpSessionScreen.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 08/05/25.
//

import SwiftUI
import Foundation

struct WarmUpSessionScreen: View {
    // Dummy pitch data
    @State var yPos = -240
    @StateObject var detector = FrequencyDetector()
    @State var xPos = 0
    var octave = 2
    var repeater = TaskRepeater()
    
   let notes = ["A5", "G5", "F5", "E5", "D5", "C5", "B4", "A4", "G4", "F4", "E4", "D4", "C4", "B3", "A3", "G3", "F3", "E3", "D3", "C3", "B2", "A2", "G2", "F2", "E2"]
   
   let activeNotes: [String: CGFloat] = [
       "C3": 0,
       "D3": 1,
       "E3": 2,
       "F3": 3,
       "G3": 4,
       "A3": 5
   ]
    
    func getCurrentNote()->Int{
        let freq = getChordByFrequency(freq: Int(detector.frequency));
        return max((freq[0] + ( (freq[1] - 1) * 12 )) - 13 , 0);
    }
   
   @State private var currentNote = "D3"
   @State private var progress: CGFloat = 0.2
   @State private var isPaused = false
    
    func changePos(){
        yPos += 1
        yPos = yPos%480
        
        xPos -= 5
    }
   
   var body: some View {
       VStack {
        
           
           Text("Lip Trills")
               .font(.headline)
               .padding(.top, 5)
           
           GeometryReader { geometry in
               ZStack(alignment: .leading) {
                   VStack(spacing: 0) {
                       ForEach(notes, id: \.self) { note in
                           HStack {
                               Text("")
                                   .font(.caption)
                                   .frame(width: 40, alignment: .leading)
                               Rectangle()
                                   .fill(Color.clear)
                                   .frame(height: 20)
                               Spacer()
                           }
                           Divider()
                       }
                   }
                   .padding(.leading)
                   
                   ForEach(0..<24){ index in
                       Rectangle()
                           .frame(width: 50, height: 20)
                           .offset(x: CGFloat(index * 50) + CGFloat(xPos), y : 240 - CGFloat(abs(abs(12-(index%24)) - 12 ))*40)
                           
                   }.zIndex(0)
                   
                   Rectangle()
                       .frame(width: 5)
                       .offset(x : 50)
                 
                   VStack(spacing: 0) {
                       Text("")
                           .font(.caption)
                           .padding(.trailing , 10)

                           .frame(width: 50, height : 20, alignment: .trailing)
                           .background(Color.white)
                       ForEach(0..<24) { note in
                           HStack {
                               Text("\(chord[(23-note)%chord.count])\(Int(floor(Double(24-note)/12)) + octave)")
                                   .font(.caption)
                                   .padding(.trailing , 10)

                                   .frame(width: 50, height : 20.3, alignment: .trailing)
                                   .background(Color.white)
                           }
                               
                       }
                   }
                   
                   
                   Image("Indicator")
                       .resizable()
                       .frame(width: 30, height : 30)
                       .offset(x : 40, y : detector.frequency <= 30 ? 244 :  (12 - CGFloat(getCurrentNote())) * CGFloat(20))
                   //CGFloat(geometry.size.hashValue) * activeNotes[currentNote]!
                   
               }
           }
           .frame(height: 480)

           Spacer()
           Text("\(detector.frequency)")
           Text(getChordString(frequency: Int(detector.frequency)))
           // Stop button
           //Text("\((10 - CGFloat(getCurrentNote())) * 24)")
           Button(action: {
               // Stop action
           }) {
               Text("Stop")
                   .font(.headline)
                   .frame(width: 100, height: 40)
                   .background(Color.red)
                   .foregroundColor(.white)
                   .cornerRadius(10)
           }
           .padding(.bottom)
           
           // Playback Control
           HStack {
               Button(action: {
                   isPaused.toggle()
               }) {
                   Image(systemName: isPaused ? "play.fill" : "pause.fill")
                       .foregroundColor(.blue)
                       .padding()
               }
               
               ProgressView(value: progress)
                   .progressViewStyle(LinearProgressViewStyle())
                   .frame(height: 10)
               
               Text("\(Int(progress * 100))s")
                   .font(.caption)
           }
           .padding([.leading, .trailing, .bottom])
       }
       .onAppear(){
           repeater.interval = 5
           repeater.tasks = changePos
           
           repeater.start()
       }
   }
}


#Preview{
    WarmUpSessionScreen()
}
