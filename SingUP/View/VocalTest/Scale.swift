//
//  Scale.swift
//  SingUP
//
//  Created by Surya on 06/05/25.
//

import SwiftUI

struct Scale: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var isAnimating = false // Track animation state

    let totalColumns = 30
    let columnWidth: CGFloat = 50
    let scrollDuration: Double = 10.0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Color.gray
                    .frame(height: geometry.size.height * 0.15)

                HStack(spacing: 0) {
                    Color.red.frame(width: geometry.size.width * 0.1)
                    Color.green.frame(width: geometry.size.width * 0.1)

                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 0) {
                            CoordinateGridView()
                                .frame(width: CGFloat(totalColumns) * columnWidth,
                                       height: geometry.size.height * 0.7)
                        }
                        .offset(x: -scrollOffset)
                    }
                    .clipped()
                }
                .frame(height: geometry.size.height * 0.7)

                ZStack {
                    Color.black

                    Button(action: {
                        if isAnimating {
                            stopAnimation()
                        } else {
                            startSmoothOffsetScroll()
                        }
                    }) {
                        Text(isAnimating ? "Stop" : "Start")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(isAnimating ? Color.red : Color.blue)
                            .cornerRadius(10)
                    }
                }
                .frame(height: geometry.size.height * 0.1)
            }
        }
        .edgesIgnoringSafeArea(.all)
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
}

// MARK: - Coordinate Grid View

struct CoordinateGridView: View {

    let xLabels = Array(1...30).map { "\($0)" }
    let yLabels = ["E2", "F2", "G2", "A2", "B2", "C3", "D3", "E3", "F3", "G3", "A3", "B3",
                   "C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5", "D5", "E5", "F5", "G5", "A5"]

    let columnWidth: CGFloat = 50

    // Custom struct to conform to Hashable
    struct GridCell: Hashable {
        let x: Int
        let y: String
    }

    var body: some View {
        GeometryReader { geo in
            let rowHeight = geo.size.height / CGFloat(yLabels.count)

            ZStack {
                Color.blue

                // Grid lines
                Path { path in
                    // Vertical lines
                    for i in 0...xLabels.count {
                        let x = CGFloat(i) * columnWidth
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geo.size.height))
                    }

                    // Horizontal lines
                    for j in 0...yLabels.count {
                        let y = CGFloat(j) * rowHeight
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geo.size.width, y: y))
                    }
                }
                .stroke(Color.white.opacity(0.5), lineWidth: 1)

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

    // MARK: - Highlight specific cells
    func highlightCells(in geo: GeometryProxy) -> some View {
        let rowHeight = geo.size.height / CGFloat(yLabels.count)

        let highlightPositions: [GridCell] = [
            GridCell(x: 3, y: "C3"), GridCell(x: 4, y: "C3"),
            GridCell(x: 5, y: "D3"), GridCell(x: 6, y: "D3"),
            GridCell(x: 7, y: "E3"), GridCell(x: 8, y: "E3")
        ]

        return Group {
            ForEach(highlightPositions, id: \.self) { position in
                if let yIndex = yLabels.firstIndex(of: position.y) {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: columnWidth, height: rowHeight)
                        .position(
                            x: CGFloat(position.x - 1) * columnWidth + columnWidth / 2,
                            y: geo.size.height - CGFloat(yIndex) * rowHeight - rowHeight / 2
                        )
                }
            }
        }
    }
}


#Preview {
    Scale()
}
