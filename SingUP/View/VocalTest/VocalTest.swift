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
    @State var isRecording = false
    @State private var animateStroke = false
    @State private var trimEnd: CGFloat = 0
    
    
    
    func getPeakFreqChord() -> String{
        if isRecording{
            print("\(peakFreq)  \(Int(detector.frequency)) \(type == 1 && Int(detector.frequency) > peakFreq) ")
            if type == 0 && Int(detector.frequency) < peakFreq && Int(detector.frequency) > 60 {
                peakFreq = Int(detector.frequency)
            }
            
            if type == 1 && Int(detector.frequency) > peakFreq{
                peakFreq = Int(detector.frequency)
            }
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
        Text("Sing 'AHH'")
            .font(.title)
            .multilineTextAlignment(.center)
            .bold(true)
        
        HStack{
            Text("as")
                .font(.title)
                .multilineTextAlignment(.center)
                .bold(true)
            
            Text("\(type == 0 ? "Lowest" : "Highest")")
                .font(.title)
                .underline()
                .foregroundStyle(type == 0 ? .blue : Color("Highest"))
                .multilineTextAlignment(.center)
                .bold(true)
            
            Text("as u Can")
                .font(.title)
                .multilineTextAlignment(.center)
                .bold(true)
        }
        .onDisappear(perform: {
            
            if type == 1{
                detector.stop()
            }
        }
        )
        
        Button(action : {}){
            Image(systemName: "arrowtriangle.\(type==0 ? "down" : "up").circle.fill")
                .foregroundStyle(Color.white)
            
            Text("Sing \(type==0 ? "Lower" : "Higher")")
                .foregroundStyle(Color.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
        .background(type == 0 ? .blue : Color("Highest"))
        
        ZStack(alignment: .bottom) {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.green.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 96) // Limit the gradient height
                .ignoresSafeArea() // Ensure it spans the screen width

            ZStack(alignment: .bottom) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.green.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 96)
                .ignoresSafeArea()

                VStack(spacing: 28) {
                    Text("\(chord[getChord()[0]])\(getChord()[1])")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.primary)
                    Text("\(peakFreq < 99999 ? peakFreq : 0) Hz")
                        .font(.title)
                        .foregroundColor(type == 0 ? .blue : .black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 70)
                .zIndex(1) // <- bring to front

                BarChartBackground(type: type)
                    .zIndex(0) // <- send to back
                    .allowsHitTesting(false) // <- don't block interaction
            }
            .frame(height: 300)

            //BarChartBackground(type: type) // Positioned at the bottom
        }
        .frame(height: 300)
        .onAppear {
            key = getChordByFrequency(freq: Int(detector.frequency))[0]
            octave = getChordByFrequency(freq: Int(detector.frequency))[1]
            peakFreq = type == 0 ? 99999 : 0
        }
        
        Button(
            action : {
                print("Ended")
                animateStroke = false
                trimEnd = 0
                isRecording = false
                
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
                //
                path.removeLast(1)
                path.append(type == 0 ? "vtest2" : "vocalresult")
            }
        ){
            ZStack {
                // Background stroke animation circle
                Circle()
                    .trim(from: 0, to: trimEnd)
                    .stroke(Color.blue, lineWidth: 8)
                    .rotationEffect(.degrees(-90)) // Start at 12 o'clock
                    .frame(width: 110, height: 110)
                    .animation(.linear(duration: 4), value: trimEnd)
                
                // Static outer circle
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundStyle(.black)
                    .frame(width: 100, height: 100)
                
                // Mic icon
                Image(systemName: "microphone.fill")
                    .resizable()
                    .frame(width: 30, height: 45)
                    .foregroundStyle(.black)
            }
            
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2)
                .onEnded { _ in
                    isRecording = true
                    print("Started")
                    
                    // Start stroke animation
                    animateStroke = true
                    trimEnd = 1.0
                }
        )
        .buttonStyle(PlainButtonStyle())
        .padding(.top, 30)
        
        Text("Hold to record, \nand release when you're done.")
            .multilineTextAlignment(.center)
            .padding(.top, 10)
        
        HStack{
            Text("Your\(type == 0 ? " Lowest" : " Highest") chord is : ")
            Text("\(getPeakFreqChord())")
                .font(.title2.bold())
        }
        .opacity(0)
    }
}

#Preview{
    @Previewable @State var path = NavigationPath()
    //ContentView()
    VocalTest(path : $path)
}

struct BarChartBackground: View {
    @State private var barHeights: [CGFloat] = Array(repeating: 0, count: 60)
    var type: Int

    var body: some View {
        ZStack(alignment: .bottom) {
            // Only show this background gradient for type == 1
            if type == 1 {
                LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.orange, Color.white, Color.white]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            }

            GeometryReader { geometry in
                HStack(alignment: .bottom, spacing: 2) {
                    ForEach(0..<barHeights.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.black.opacity(0.2))
                            .frame(
                                width: geometry.size.width / CGFloat(barHeights.count) - 2,
                                height: type == 1
                                    ? barHeights[index]
                                    : min(max(barHeights[index], 4), 24)
                            )
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(maxHeight: type == 1 ? .infinity : 24, alignment: .bottom) // type 0 has fixed height
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.2)) {
                    barHeights = barHeights.map { _ in
                        type == 1
                        ? CGFloat.random(in: 4...164)
                        : CGFloat.random(in: 4...24)
                    }
                }
            }
        }
    }
}
