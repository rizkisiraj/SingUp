//
//  ScaleTraining.swift
//  SingUP
//
//  Created by Surya on 08/05/25.
//

import SwiftUI
import Foundation
import AVFoundation
import Accelerate
import AudioKit
import AudioKitEX
import AudioToolbox
import SoundpipeAudioKit
import SwiftData

let kAudioUnitSubType_DLSSynth: OSType = 0x646c7320 // 'dls '

struct NoteEvent {
    let noteNumber: UInt8
    let time: Double
    let duration: Double
}

struct ScaleTraining: View {
    
    @Binding var path : NavigationPath
    @State private var highlights: [HighlightCell] = []
    @State private var shouldNavigate = false
    @State private var timePerColumn: Double = 1.0
    @State private var lastYIndex: Int = 0
    @State private var lastUpdateTime: Date = .now

    @State private var engine = AudioEngine()
    @State private var sampler = MIDISampler()

    @State private var sequencer = AppleSequencer()
    @State private var midiPlayer: AVMIDIPlayer?
    @State private var introPlayer: AVAudioPlayer? = nil
    
    // MARK: AAA
    @State private var elapsedTime: Double = 0
    @State private var timer: Timer? = nil
    @State private var showCountdownBar = false
    @State private var isNarrating = true
    @State private var totalDuration = 20.0
    let updateInterval: Double = 0.05
    
    // MARK: AAA
    @State private var scrollOffset: CGFloat = 0
    @State private var isAnimating = false // Track animation state
    @State private var currentYIndex: Int = 8 // Index for "C3" as starting point
    @StateObject private var pitchManager = PitchManager()
    @State private var isPitchMovementActive = false
    @State private var interpolatedY: CGFloat = 11.0 // nilai antar yIndex

    
    let yLabels = ["C5", "B4", "A4", "G4", "F4", "E4", "D4", "C4", "B3", "A3", "G3", "F3", "E3", "D3", "C3", "B2", "A2", ""]


    var totalColumns: Int {
        Int(ceil(scrollDuration / visualTimePerColumn))
    }

    let columnWidth: CGFloat = 50
    @State private var visualTimePerColumn: Double = 0.2
    @State private var scrollDuration: Double = 30.0
    
    let noteToLabelMap: [UInt8: String] = Dictionary(uniqueKeysWithValues:
        (48...84).map { ($0, noteNumberToName($0)) }
    )

    static func noteNumberToName(_ note: UInt8) -> String {
        let names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let octave = Int(note) / 12 - 1
        let name = names[Int(note) % 12]
        return "\(name)\(octave)"
    }

    var body: some View {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Color.white
                        .frame(height: geometry.size.height * 0.15)
                        .ignoresSafeArea(edges: .top)
                    Text("Session 1 of 1")
                    ProgressView(value: elapsedTime, total: totalDuration)
                        .progressViewStyle(LinearProgressViewStyle())
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .animation(.linear(duration: 0.05), value: elapsedTime)
                        .padding()
                    Color.white
                        .frame(height: geometry.size.height * 0.05)
                    // Grid View and etc
                    HStack(spacing: 0) {
                        ZStack(alignment: .top) {
                            // MARK: DEBUG RED
                            Color.white
                            
                        }
                        .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.7)
                        .zIndex(0) // Keep the red section behind
                        
                        // MARK: GREEN
                        GeometryReader { geo in
                            let cellHeight = geo.size.height / CGFloat(yLabels.count)
                            let rowHeight = geo.size.height / CGFloat(yLabels.count)

                            
                            ZStack(alignment: .top) {
                                // Center vertical line (full height)
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 5, height: geo.size.height )
                                    .position(x: geo.size.width / 2 + 100, y: geo.size.height / 2)
                                
                                // Horizontal lines
                                ForEach(0..<yLabels.count, id: \.self) { i in
                                    Rectangle()
                                        .fill(Color.black.opacity(0.1))
                                        .frame(height: 1)
                                        .position(x: geo.size.width / 2 + 100,
                                                  y: cellHeight * CGFloat(i))
                                }
                                
                                // Blue dot
                                ForEach(yLabels.indices, id: \.self) { index in
                                    if index == currentYIndex {
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color("pink"), Color("ungu")]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: 32, height: 32)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.black.opacity(0.6), lineWidth: 5)
                                                )
                                            
                                            Image(systemName: "music.note")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 14, height: 14)
                                                .foregroundColor(.black)
                                        }
                                        .position(
                                            x: geo.size.width / 2 + 100,
                                            y: rowHeight * (interpolatedY + 0.5)
                                        )
                                        .animation(.easeOut(duration: 0.07), value: interpolatedY)
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width * 0.0, height: geometry.size.height * 0.6)
                        .background(Color.green.opacity(0.4))
                        .zIndex(2) // Green section goes on top
                        
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(spacing: 0) {
                                CoordinateGridViewScale(highlightPositions: highlights, scrollOffset: scrollOffset)
                                    .frame(width: CGFloat(totalColumns) * columnWidth,
                                           height: geometry.size.height * 0.6)
                            }
                            .offset(x: -scrollOffset)
                        }
                        .clipped()
                        .zIndex(0) // Grid view stays below the green section
                    }
                    .frame(height: geometry.size.height * 0.6)
                    
                    ZStack {
                        Color.white
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                    // Action to perform when the button is tapped
                                  }) {
                                    Label("Pause", systemImage: "play.fill")
                                      .padding()
                                      .foregroundColor(.white)
                                      .background(Color.blue)
                                      .cornerRadius(10)
                                  }

                            // Fixed height container to avoid jump
                            ZStack {
                                if showCountdownBar {
                                    CountdownProgressBar(progress: min(elapsedTime / totalDuration, 1.0),
                                                         timeRemaining: Int(ceil(totalDuration - elapsedTime)))
                                }
                            }
                            .frame(height: 30)
                            .padding(.horizontal)
                        }
                    }
                    .frame(height: geometry.size.height * 0.15)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                history = History(context : context)
                pitchManager.onPitchDetected = { pitch in
                    let midi = 69 + 12 * log2(Double(pitch) / 440)
                    let minMIDINote = 40  // E2
                    let maxMIDINote = 81  // A5

                    if !isNarrating {
                        let roundedMIDINote = UInt8(round(midi))
                                let noteName = ScaleTraining.noteNumberToName(roundedMIDINote)

                                if let index = yLabels.firstIndex(of: noteName) {
                                    if interpolatedY != CGFloat(index) {
                                        interpolatedY = CGFloat(index)
//                                        print("🎯 pitch: \(pitch), midi: \(midi), noteName: \(ScaleTraining.noteNumberToName(UInt8(round(midi))))")
                                    }
                                    
//                                    print("index: \(index)")
//                                    print("interpolatedY: \(interpolatedY)")
                                }

                        
                    }

                }
                if let midiURL = Bundle.main.url(forResource: "no name (2)", withExtension: "mid") {
                    let events = loadNoteEvents(from: midiURL)
//                    highlights = mapEventsToGrid(events)
                    
                    if let lastNote = events.max(by: { $0.time < $1.time }) {
                            let midiLength = events.map { $0.time + $0.duration }.max() ?? 1.0
                            let preferredColumnDuration = 0.2 // 🧠 1 kolom = 0.2 detik → lebih pelan
                            timePerColumn = preferredColumnDuration
                            scrollDuration = midiLength * 2
                            totalDuration = midiLength
                            highlights = mapEventsToGrid(events)
                            
                            print("🧩 visualTimePerColumn: \(visualTimePerColumn)")

                            // totalColumns will be used for visual only
                            let newTotalColumns = Int(ceil(midiLength / preferredColumnDuration))
                            print("🎯 Scroll duration: \(scrollDuration)s, totalColumns: \(newTotalColumns)")
                        }

                    do {
//                        try sampler.loadSoundFont("mysf", preset: 2, bank: 0) // make sure "mysf.sf2" is in the bundle
//                        try sequencer.loadMIDIFile(fromURL: midiURL)
//                        sequencer.setGlobalMIDIOutput(sampler.midiIn)
//                        sequencer.rewind()
//                        sampler.volume = 1.8
//                        engine.output = sampler
//                        try engine.start()
//
//                        // optional: sync scroll duration to sequencer length
//                        let length = sequencer.length
//                        playSoundAudio()
                        

                    } catch {
                        print("❌ AppleSequencer setup failed: \(error)")
                    }
                }




            }
            .onDisappear {
                introPlayer?.stop()
                introPlayer = nil
            }
            .overlay {
                if isNarrating {
                    WelcomeChatOverlay {
                        isNarrating = false
                        if isAnimating {
                            stopAnimation()
                            isPitchMovementActive = false
                            timer?.invalidate()
                            showCountdownBar = false
                            sequencer.stop()
                        } else {
                            do {
                                try engine.start()
                                sampler.volume = 2.0
                                sequencer.rewind()

                                let delay: Double = 0.3 // ⏱ Try tweaking between 0.05–0.15
                                
                                let startTime = Date()

                                Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { timer in
                                    let elapsed = Date().timeIntervalSince(startTime)
                                    let progress = min(elapsed / scrollDuration, 1.0)
                                    scrollOffset = CGFloat(progress) * CGFloat(totalColumns - 1) * columnWidth

                                    if progress >= 1.0 {
                                        timer.invalidate()
                                    }
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    playSoundAudio()
                                    startTimer()
                                }

                                print("🎞️ Scroll from 0 → \(scrollOffset) in \(scrollDuration)s")
                                isPitchMovementActive = true
                                isAnimating = true
                                
                                showCountdownBar = true
                            } catch {
                                print("❌ Engine start failed: \(error)")
                            }
                        }
                        
                    }
                }
            }
            .navigationDestination(isPresented: $shouldNavigate) {
                ScaleCompleted(history: $history, path: $path) // <- replace with your actual destination view
            }
        }
        
    // MARK: WITH MAX AND MINIMUM NOTES
    func handlePitchChange(_ pitch: Float) {
        guard isPitchMovementActive else { return }

        let minYIndex = yLabels.firstIndex(of: "C3") ?? 0  // Lower bound
        let maxYIndex = yLabels.firstIndex(of: "D4") ?? yLabels.count - 1  // Upper bound

        if pitch > 100, currentYIndex > maxYIndex {
            currentYIndex -= 1
        } else if pitch < 99, currentYIndex < minYIndex {
            currentYIndex += 1
        }
    }
    @Environment(\.modelContext) var context
        @State var history : History?
    
    func frequencyToNoteNumber(_ frequency: Float) -> Int {
        return Int(round(12 * log2(frequency / 440.0) + 69))
    }
    
    func playSoundAudio() {
        guard let url = Bundle.main.url(forResource: "cobaan", withExtension: "mp3") else { return }
        do {
            introPlayer = try AVAudioPlayer(contentsOf: url)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                introPlayer?.play()
            }
                        
        } catch {
            print("Failed to play intro audio: \(error)")
        }
    }

    func noteNumberToYIndex(_ noteNumber: Int) -> Int? {
        let noteName = ScaleTraining.noteNumberToName(UInt8(noteNumber))
        return yLabels.firstIndex(of: noteName)
    }

    func yLabelToMIDINote(_ label: String) -> Int? {
        let names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let regex = try! NSRegularExpression(pattern: "([A-G]#?)(\\d)")
        guard let match = regex.firstMatch(in: label, range: NSRange(label.startIndex..., in: label)),
              let nameRange = Range(match.range(at: 1), in: label),
              let octaveRange = Range(match.range(at: 2), in: label)
        else { return nil }

        let name = String(label[nameRange])
        let octave = Int(label[octaveRange]) ?? 0
        guard let noteIndex = names.firstIndex(of: name) else { return nil }

        return (octave + 1) * 12 + noteIndex
    }

    
    // MARK: Without Minimum
    
    func pitchToStep(_ pitch: Float) -> Int {
        if pitch > 250 { return -1 } // lower (e.g., D4 → C4)
        if pitch < 180 { return 1 }  // higher (e.g., C4 → D4)
        return 0
    }

    // Start smooth scroll animation
    func startSmoothOffsetScroll() {
        isAnimating = true
        scrollOffset = 0

        withAnimation(.linear(duration: scrollDuration * 2)) {
            scrollOffset = CGFloat(totalColumns - 1) * columnWidth
        }
    }

    // Stop the animation, reset the scroll, and return to the initial position
    func stopAnimation() {
        isAnimating = false
        sequencer.stop()
        withAnimation(.linear(duration: 0)) {
            scrollOffset = 0
        }
    }
    
    func updateDotPosition(for pitch: Float) {
        let thresholdUp: Float = 100.0  // Adjust for your voice profile
        let thresholdDown: Float = 80.0

        if pitch > thresholdUp && currentYIndex > 0 {
            currentYIndex -= 1  // Move up
        } else if pitch < thresholdDown && currentYIndex < yLabels.count - 1 {
            currentYIndex += 1  // Move down
        }
    }
    
    func frequencyToMIDINote(_ frequency: Float) -> UInt8 {
        return UInt8(round(69 + 12 * log2(frequency / 440.0)))
    }

    
    func startTimer() {
        elapsedTime = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { t in
            if elapsedTime < totalDuration {
                elapsedTime += updateInterval
            } else {
                t.invalidate()
                stopAnimation() // <-- Reset grid when time is up
                isPitchMovementActive = false
                shouldNavigate = true // <- Trigger navigation
            }
        }
    }
    
    func loadNoteEvents(from url: URL) -> [NoteEvent] {
            var noteEvents: [NoteEvent] = []
            do {
                let midiFile = try MIDIFile(url: url)
                for track in midiFile.tracks {
                    var pendingNotes: [UInt8: Double] = [:]
                    let beatsPerMinute = 120.0
                    let secondsPerBeat = 60.0 / beatsPerMinute
                    for event in track.events {
                        guard let midiEvent = try? MIDIEvent(data: event.data),
                              let status = midiEvent.status else { continue }

                        let statusByte = status.byte
                        let type = statusByte & 0xF0
                        let note = midiEvent.data[safe: 1] ?? 0
                        let velocity = midiEvent.data[safe: 2] ?? 0
                        let beatPos = event.positionInBeats ?? 0
                        let time = beatPos * secondsPerBeat

                        if type == 0x90 && velocity > 0 {
                            pendingNotes[note] = time
                        } else if (type == 0x80 || (type == 0x90 && velocity == 0)), let startTime = pendingNotes[note] {
                            let duration = time - startTime
                            noteEvents.append(NoteEvent(noteNumber: note, time: startTime, duration: duration))
                            pendingNotes.removeValue(forKey: note)
                        }
                    }
                }
            } catch {
                print("Failed to read MIDI: \(error)")
            }
            return noteEvents
        }

    func mapEventsToGrid(_ events: [NoteEvent]) -> [HighlightCell] {
        let midiLength = events.map { $0.time + $0.duration }.max() ?? 1.0
        let timePerColumn = visualTimePerColumn // ✅ pakai yang di state

        return events.compactMap { event in
            guard let y = noteToLabelMap[event.noteNumber] else { return nil }
            let x = Int(round(event.time / timePerColumn)) + 1
            let label = getSolfege(for: event.noteNumber)
            let durationScaleFactor = 0.3
            let scaledDuration = event.duration * durationScaleFactor
            let widthInColumns = max(1, Int(round(event.duration / visualTimePerColumn)))
            print("🎵 Note \(event.noteNumber) | Start: \(event.time)s | Duration: \(event.duration)s → WidthCols: \(widthInColumns)")
            print("🎵 Note \(event.noteNumber): \(event.duration)s → widthCols: \(widthInColumns)")
            return HighlightCell(x: x, y: y, label: label, width: widthInColumns)
        }
    }





        func getSolfege(for note: UInt8) -> String {
            switch note % 12 {
            case 0: return "Do"
            case 2: return "Re"
            case 4: return "Mi"
            case 5: return "Fa"
            case 7: return "So"
            case 9: return "La"
            case 11: return "Ti"
            default: return "-"
            }
        }
    
}

// MARK: - Coordinate Grid View

// MARK: - COORDINATE GRID WITH yLabel, xLabel and vertical line
struct CoordinateGridViewScale: View {

    let xLabels = Array(1...18).map { "\($0)" }
    let yLabels = ["","A2", "B2", "C3", "D3", "E3", "F3", "G3",
                   "A3", "B3", "C4", "D4", "E4", "F4", "G4",
                   "A4", "B4", "C5"]
    

    let columnWidth: CGFloat = 50
    var highlightPositions: [HighlightCell]
    var scrollOffset: CGFloat
    


    // Custom struct to conform to Hashable
    struct GridCell: Hashable {
        let x: Int
        let y: String
    }

    var body: some View {
        GeometryReader { geo in
            let rowHeight = geo.size.height / CGFloat(yLabels.count)

            ZStack {
                Color.white

                // Grid lines
                Path { path in


                    // Horizontal lines
                    for j in 0...yLabels.count {
                        let y = CGFloat(j) * rowHeight
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geo.size.width, y: y))
                    }
                }
                .stroke(Color.black.opacity(0.1), lineWidth: 1)

                // Highlighted black cells
                highlightCells(in: geo)

                // X-axis labels with scroll target IDs
//                ForEach(0..<xLabels.count, id: \.self) { i in
//                    Text(xLabels[i])
//                        .font(.caption2)
//                        .foregroundColor(.black)
//                        .position(
//                            x: CGFloat(i) * columnWidth + columnWidth / 2,
//                            y: geo.size.height - 10
//                        )
//                        .id("cell_\(i + 1)") // ID for scrolling
//                }

                // Y-axis labels
                ForEach(0..<yLabels.count, id: \.self) { j in
                    Text(yLabels[j])
                        .font(.caption2)
                        .foregroundColor(.white)
                        .position(
                            x: 20,
                            y: geo.size.height - CGFloat(j) * rowHeight - rowHeight / 2
                        )
                }
            }
        }
    }
    
    // MARK: FUNC WITH TEXT GRID
    func highlightCells(in geo: GeometryProxy) -> some View {
        let rowHeight = geo.size.height / CGFloat(yLabels.count)
        let lineX = geo.size.width / 2 + 100 // must match actual line position

        
        
        return Group {
            ForEach(highlightPositions) { position in
                if let yIndex = yLabels.firstIndex(of: position.y) {
                    let xPos = CGFloat(position.x - 1) * columnWidth + (CGFloat(position.width) * columnWidth) / 2
                    let yPos = geo.size.height - CGFloat(yIndex) * rowHeight - rowHeight / 2
                    let lineX = geo.size.width / 2 + 100 // must match actual line position
                    let cellX = CGFloat(position.x - 1) * columnWidth
                    let cellXOnScreen = cellX - scrollOffset // +100 to align grid position with the vertical line
                    
                    let hasPassedLine = cellXOnScreen < 7.0

                    let fillColor: LinearGradient = !hasPassedLine
                        ? LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray]), startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(gradient: Gradient(colors: [Color("pink"), Color("ungu")]), startPoint: .leading, endPoint: .trailing)
                    
                    
                    ZStack {
                        Rectangle()
                            .fill(fillColor)
                            .frame(width: columnWidth * CGFloat(position.width), height: rowHeight)
                            .cornerRadius(20)

                        
                        VStack {
                            Text(position.label)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    .position(x: xPos + 100, y: yPos)
                }
            }
        }
    }

}

class PitchManager: ObservableObject {
    private let engine = AudioEngine()
    private let mic: AudioEngine.InputNode
    private var pitchTap: PitchTap!
    private var recentPitches: [Float] = []
    private let smoothingWindowSize = 3

    var onPitchDetected: ((Float) -> Void)?

    init() {
        guard let input = engine.input else {
            fatalError("❌ No audio input available")
        }
        self.mic = input

        pitchTap = PitchTap(mic) { pitch, amp in
            guard let freq = pitch.first, amp.first ?? 0 > 0.01 else { return }

            let smoothed = self.smoothedPitch(Float(freq))
            if smoothed > 60 && smoothed < 1500 { // typical human range
                DispatchQueue.main.async {
                    self.onPitchDetected?(smoothed)
                }
            }
        }

        pitchTap.start()
        engine.output = Fader(mic, gain: 0) // silent mic passthrough
        do {
            try engine.start()
        } catch {
            print("❌ AudioEngine failed to start: \(error)")
        }
    }





    private func smoothedPitch(_ newPitch: Float) -> Float {
        recentPitches.append(newPitch)
        if recentPitches.count > smoothingWindowSize {
            recentPitches.removeFirst()
        }
        return recentPitches.reduce(0, +) / Float(recentPitches.count)
    }
}


extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

// MARK: PROGRESS BAR INDICATOR
struct CountdownProgressBar: View {
    let progress: Double
    let timeRemaining: Int

    var body: some View {
        HStack {
            Button(action: {
                    // Action for pausing the progress (toggle state)
                    print("Pause button tapped")
                }) {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }
                .frame(maxHeight: .infinity)
            
        }
        .padding()
    }
}

//#Preview {
//    ScaleTraining(path: .constant(NavigationPath()))
//}

