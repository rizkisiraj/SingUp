//
//  SustainTraining.swift
//  SingUP
//
//  Created by Surya on 08/05/25.
//

import SwiftUI
import Foundation
import AVFoundation
import Accelerate

struct SustainTraining: View {
    
    @Binding var path : NavigationPath
    
    @State private var shouldNavigate = false
    
    // MARK: AAA
    @State private var elapsedTime: Double = 0
    @State private var timer: Timer? = nil
    @State private var showCountdownBar = false

    let totalDuration: Double = 20.0
    let updateInterval: Double = 0.05
    
    // MARK: AAA
    @State private var scrollOffset: CGFloat = 0
    @State private var isAnimating = false // Track animation state
    @State private var currentYIndex: Int = 19 // Index for "C3" as starting point
    @StateObject private var pitchManager = PitchManager()
    @State private var isPitchMovementActive = false

    
    let yLabels = ["A5", "G5", "F5", "E5", "D5", "C5", "B4", "A4", "G4", "F4", "E4", "D4", "C4", "B3", "A3", "G3", "F3", "E3", "D3", "C3", "B2", "A2", "G2", "F2","E2", " "]

    let totalColumns = 30
    let columnWidth: CGFloat = 100
    let scrollDuration: Double = 26.0

    var body: some View {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Color.white
                        .frame(height: geometry.size.height * 0.15)
                        .ignoresSafeArea(edges: .top)
                    // Grid View and etc
                    HStack(spacing: 0) {
                        ZStack(alignment: .top) {
                            // MARK: DEBUG RED
                            Color.white
                            
                            GeometryReader { geo in
                                let cellHeight = geo.size.height / CGFloat(yLabels.count)
                                
                                // Horizontal lines
                                ForEach(0..<yLabels.count, id: \.self) { i in
                                    Rectangle()
                                        .fill(Color.black.opacity(0.1))
                                        .frame(height: 1)
                                        .position(x: geo.size.width / 2,
                                                  y: cellHeight * CGFloat(i))
                                }
                                
                                // Labels
                                VStack(spacing: 0) {
                                    ForEach(yLabels.indices, id: \.self) { index in
                                        Text(yLabels[index])
                                            .font(.caption2)
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: cellHeight)
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.7)
                        .zIndex(0) // Keep the red section behind
                        
                        // MARK: GREEN
                        GeometryReader { geo in
                            let cellHeight = geo.size.height / CGFloat(yLabels.count)
                            
                            ZStack(alignment: .top) {
                                // Center vertical line (full height)
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 2, height: geo.size.height)
                                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                                
                                // Horizontal lines
                                ForEach(0..<yLabels.count, id: \.self) { i in
                                    Rectangle()
                                        .fill(Color.black.opacity(0.1))
                                        .frame(height: 1)
                                        .position(x: geo.size.width / 2,
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
                                                .frame(width: 22, height: 22)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.black.opacity(0.6), lineWidth: 1) // Black outline
                                                )
                                            
                                            Image(systemName: "music.note")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 14, height: 14)
                                                .foregroundColor(.black)
                                        }
                                        .position(
                                            x: geo.size.width / 2,
                                            y: cellHeight * CGFloat(index) + cellHeight / 2
                                        )
                                        .zIndex(1)
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width * 0.0, height: geometry.size.height * 0.7)
                        .background(Color.green.opacity(0.4))
                        .zIndex(2) // Green section goes on top
                        
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(spacing: 0) {
                                CoordinateGridViewSustain()
                                    .frame(width: CGFloat(totalColumns) * columnWidth,
                                           height: geometry.size.height * 0.7)
                            }
                            .offset(x: -scrollOffset)
                        }
                        .clipped()
                        .zIndex(0) // Grid view stays below the green section
                    }
                    .frame(height: geometry.size.height * 0.7)
                    
                    ZStack {
                        Color.white
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                if isAnimating {
                                    stopAnimation()
                                    isPitchMovementActive = false
                                    timer?.invalidate()
                                    showCountdownBar = false
                                } else {
                                    startSmoothOffsetScroll()
                                    isPitchMovementActive = true
                                    startTimer()
                                    showCountdownBar = true
                                }
                            }) {
                                Text(isAnimating ? "Stop" : "Start")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(isAnimating ? Color.red : Color.blue)
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
                pitchManager.onPitchDetected = { pitch in
                    handlePitchChange(pitch)
                }
            }
            .navigationDestination(isPresented: $shouldNavigate) {
                SustainCompleted(path: $path) // <- replace with your actual destination view
            }
            
        }
        
    // MARK: WITH MAX AND MINIMUM NOTES
    func handlePitchChange(_ pitch: Float) {
        guard isPitchMovementActive else { return }

        let minYIndex = yLabels.firstIndex(of: "C3") ?? 0  // Lower bound
        let maxYIndex = yLabels.firstIndex(of: "B3") ?? yLabels.count - 1  // Upper bound

        if pitch > 100, currentYIndex > maxYIndex {
            currentYIndex -= 1
        } else if pitch < 99, currentYIndex < minYIndex {
            currentYIndex += 1
        }
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
        withAnimation(.linear(duration: scrollDuration)) {
            scrollOffset = CGFloat(totalColumns - 1) * columnWidth
        }
    }

    // Stop the animation, reset the scroll, and return to the initial position
    func stopAnimation() {
        isAnimating = false
        withAnimation(.linear(duration: 0)) {  // Add a smooth transition back to the starting position
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
    
}

// MARK: - Coordinate Grid View

// MARK: - COORDINATE GRID WITH yLabel, xLabel and vertical line
struct CoordinateGridViewSustain: View {

    let xLabels = Array(1...30).map { "\($0)" }
    let yLabels = ["" ,"E2", "F2", "G2", "A2", "B2", "C3", "D3", "E3", "F3", "G3", "A3", "B3",
                   "C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5", "D5", "E5", "F5", "G5", "A5"]

    let columnWidth: CGFloat = 70

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
                ForEach(0..<xLabels.count, id: \.self) { i in
                    Text(xLabels[i])
                        .font(.caption2)
                        .foregroundColor(.white)
                        .position(
                            x: CGFloat(i) * columnWidth + columnWidth / 2,
                            y: geo.size.height - 10
                        )
                        .id("cell_\(i + 1)") // ID for scrolling
                }

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

        // Each position now includes a label
        let highlightPositions: [(GridCell, String)] = [
            (GridCell(x: 2, y: "C3"), "Ahh"),
            (GridCell(x: 3, y: "E3"), "Ahh"),
            (GridCell(x: 4, y: "G3"), "Ahh"),
            (GridCell(x: 5, y: "B3"), "Ahh"),
            (GridCell(x: 6, y: "G3"), "Ahh"),
            (GridCell(x: 7, y: "E3"), "Ahh"),
            (GridCell(x: 8, y: "C3"), "Ahh"),
            (GridCell(x: 9, y: "E3"), "Ahh"),
            (GridCell(x: 10, y: "G3"), "Ahh"),
            (GridCell(x: 11, y: "B3"), "Ahh"),
            (GridCell(x: 12, y: "G3"), "Ahh"),
            (GridCell(x: 13, y: "E3"), "Ahh"),
            (GridCell(x: 14, y: "C3"), "Ahh"),
            (GridCell(x: 15, y: "E3"), "Ahh"),
            (GridCell(x: 16, y: "G3"), "Ahh"),
            (GridCell(x: 17, y: "B3"), "Ahh"),
            (GridCell(x: 18, y: "G3"), "Ahh"),
            (GridCell(x: 19, y: "E3"), "Ahh"),
            (GridCell(x: 20, y: "C3"), "Ahh"),
            (GridCell(x: 21, y: "E3"), "Ahh"),
            (GridCell(x: 22, y: "G3"), "Ahh"),
            (GridCell(x: 23, y: "B3"), "Ahh"),
            (GridCell(x: 24, y: "G3"), "Ahh"),
            (GridCell(x: 25, y: "E3"), "Ahh"),
            (GridCell(x: 26, y: "C3"), "Ahh"),
            (GridCell(x: 27, y: "E3"), "Ahh"),
            (GridCell(x: 28, y: "G3"), "Ahh"),
            (GridCell(x: 29, y: "B3"), "Ahh"),
            (GridCell(x: 30, y: "G3"), "Ahh"),
            (GridCell(x: 31, y: "E3"), "Ahh"),
            (GridCell(x: 32, y: "C3"), "Ahh"),
        ]

        return Group {
            ForEach(highlightPositions, id: \.0) { (position, label) in
                if let yIndex = yLabels.firstIndex(of: position.y) {
                    let xPos = CGFloat(position.x - 1) * columnWidth + columnWidth / 2
                    let yPos = geo.size.height - CGFloat(yIndex) * rowHeight - rowHeight / 2

                    ZStack {
                        // Black note cell with label inside
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color("pink"), Color("ungu")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: columnWidth, height: rowHeight)
                            .cornerRadius(20) // <-- Rounded corners

                        Text(label)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .position(x: xPos, y: yPos)
                }
            }
        }
    }
}

//#Preview {
//    SustainTraining()
//}
