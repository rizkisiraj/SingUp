//
//  HistoryPage.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import Charts
import SwiftUI

// Model
struct ValuePoint: Identifiable {
    let id = UUID()
    let index: Int   // Start from 1
    let value: Int
}

// Line Chart View
struct LineChartView: View {
    let values: [Int]
    
    var body: some View {
        // Create data points with index starting from 1
        let dataPoints = values.enumerated().map { ValuePoint(index: $0.offset + 1, value: $0.element) }
        
        Chart(dataPoints) { point in
            // Area background under the line
            AreaMark(
                x: .value("Index", point.index),
                y: .value("Value", point.value)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Line connecting the points
            LineMark(
                x: .value("Index", point.index),
                y: .value("Value", point.value)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(.blue)
            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
            
            // Dot at each point
            PointMark(
                x: .value("Index", point.index),
                y: .value("Value", point.value)
            )
            .foregroundStyle(.blue)
            .annotation(position: .top) {
                Text("\(point.value)")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
        // Custom X-axis labels
        .chartXAxis {
            AxisMarks(values: .stride(by: 1)) {
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        // Custom Y-axis labels (10–100)
        .chartYAxis {
            AxisMarks(values: Array(stride(from: 10, through: 100, by: 10))) {
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartYScale(domain: 0...100)
        .chartXScale(domain: 1...values.count)
        .frame(height: 300)
        .padding()
        
        // Native List Below Chart
        HStack {
            Text("Attempt")
            Spacer()
            Text("Accuracy")
        }
        .padding()
        List(dataPoints) { point in
            HStack {
                Text("\(point.index).")
                Spacer()
                Text("Date")
                Spacer()
                Text("\(point.value) %")
            }
        }
        .listStyle(.plain) // Optional: cleaner look
    }
}

// Preview or usage in ContentView
struct HistoryPage: View {
    var body: some View {
        LineChartView(values: [10, 20, 30, 50, 40, 80, 90, 100])
    }
}


#Preview {
    HistoryPage()
}
