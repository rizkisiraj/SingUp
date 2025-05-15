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
    
    @State var values: [Int]
    var history : History?
    enum Exercise : String, CaseIterable, Identifiable{
        case sustain
        case scale
        var id : Self {self}
    }
    
    @State var selectedExercise: Exercise = .scale
    
    var body: some View {
        
        Text("History")
            .font(.largeTitle.bold())
        
        
        
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
                    gradient: Gradient(colors: [selectedExercise == .scale ? Color.blue.opacity(0.3) : Color.green.opacity(0.3), selectedExercise == .scale ? Color.blue.opacity(0.0) : Color.green.opacity(0.0)]),
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
            .foregroundStyle(selectedExercise == .scale ? Color.blue : Color.green)
            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
            
            // Dot at each point
            PointMark(
                x: .value("Index", point.index),
                y: .value("Value", point.value)
            )
            .foregroundStyle(selectedExercise == .scale ? Color.blue : Color.green)
            .annotation(position: .top) {
                Text("\(point.value)")
                    .font(.caption2)
                    .foregroundColor(selectedExercise == .scale ? Color.blue : Color.green)
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
        .chartXScale(domain: 1...(values.count > 0 ? values.count : 10))
        .frame(height: 250)
        .padding()
        
        Picker("Exercise", selection: $selectedExercise ){
            Text("Sustain")
                .tag(Exercise.sustain)
            Text("Scale")
                .tag(Exercise.scale)
            
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        
        // Native List Below Chart
        HStack {
            Text("Exercise")
                .font(.title2.bold())
            Spacer()
            Text("Accuracy")
                .font(.title2.bold())

        }
        .padding()
        
        ScrollView{
            ForEach(Array((history?.fetchAll(type : selectedExercise == .scale ? 0 : 1) ?? []).enumerated()), id: \.offset) { index, hist in
                HStack {
                    Image(selectedExercise == .scale ? "ScaleExercise" : "SustainExercise")
                    Spacer()
                    
                    VStack{
                        Text(selectedExercise == .scale ? "ScaleExercise" : "SustainExercise")
                            .font(.title2.bold())
                            .foregroundStyle(selectedExercise == .scale ? .blue : .green)
                            .frame(maxWidth : .infinity, alignment : .leading)
                        
                        Text("Percobaan : \(index)")
                            .frame(maxWidth : .infinity, alignment : .leading)
                        
                    }
                   
                    Spacer()
                    VStack{
                        Text("\(Int(hist.accuracy))%")
                            .font(.title.bold())
                        Text("Accuracy")
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius : 10)
                        .fill(selectedExercise == .scale ? .blue.opacity(0.1) : .green.opacity(0.1))
                )
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            //history?.deleteAll()
            var arr = [Int]()
            for val in history?.fetchAll(type : selectedExercise == .scale ? 0 : 1) ?? [] {
                arr.append(Int(val.accuracy))
            }
            self.values = arr
        }
       
    }
}
// Preview or usage in ContentView
struct HistoryPage: View {
    @Binding var history : History?
    var body: some View {
        LineChartView(values: [10, 20, 30, 50, 40, 80, 90, 100], history : history)
        
    }
}


#Preview {
    HistoryPage(history : .constant(nil))
}
