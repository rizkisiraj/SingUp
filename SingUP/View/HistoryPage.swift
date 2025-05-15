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
    @State var limit = 5
    @State var values: [Int]
    var history : History?
    enum Exercise : String, CaseIterable, Identifiable{
        case sustain
        case scale
        var id : Self {self}
    }
    @State var dataPoints: [ValuePoint] = []
    @State var selectedExercise: Exercise = .scale
    
    func fetchData (adding : Int = 0) -> [VocalTraining]{
        var data = history?.fetchAll(type : selectedExercise == .scale ? 0 : 1) ?? []
        var arr = [Int]()
        for val in data{
            arr.append(Int(val.accuracy))
        }
        self.values = arr
        if adding == 1 && data.count == 1{
            data.insert(
                VocalTraining(id : UUID(), date : Date(), exercise: 0, accuracy: 60), at: 0)
        }
        return data
    }
    
    var body: some View {
        ScrollView{
            Text("History")
                .font(.largeTitle.bold())
                .padding(.top, 20)
            
            
            // Create data points with index starting from 1
           
            
            Chart(Array((fetchData(adding : 1)).enumerated()), id: \.offset) { index, hist in
                // Area background under the line
                AreaMark(
                    x: .value("Index", index+1),
                    y: .value("Value", Int(hist.accuracy))
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
                    x: .value("Index", index+1),
                    y: .value("Value", Int(hist.accuracy))
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(selectedExercise == .scale ? Color.blue : Color.green)
                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
                
                // Dot at each point
                PointMark(
                    x: .value("Index", index+1),
                    y: .value("Value", Int(hist.accuracy))
                )
                .foregroundStyle(selectedExercise == .scale ? Color.blue : Color.green)
                .annotation(position: .top) {
                    Text("\(Int(hist.accuracy))")
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
            .chartXScale(domain: 1...(values.count > 1 ? values.count : 3))
            .frame(height: 250)
            .padding()
            
            Picker("Exercise", selection: $selectedExercise ){
              
                Text("Scale")
                    .tag(Exercise.scale)
                Text("Sustain")
                    .tag(Exercise.sustain)
                
                
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            
            Text("This is your history data for the \(selectedExercise == .scale ? "Scale" : "Sustain" ) exercise. These data was stored from your last vocal exercise session.")
                .multilineTextAlignment(.leading)
                .font(.caption)
                .frame(maxWidth : .infinity, alignment : .leading)
                .padding(.horizontal)
            // Native List Below Chart
            HStack {
                Text("Exercise")
                    .font(.title2.bold())
                Spacer()
                Text("Accuracy")
                    .font(.title2.bold())
                
            }
            .padding()
            
            VStack{
                
                if history?.fetchAll(type : selectedExercise == .scale ? 0 : 1).count ?? 0 == 0{
                    Text("No history data available")
                        .padding(.vertical, 50)
                        .frame(maxHeight: .infinity)
                }else {
                    ForEach(Array(( fetchData()).enumerated()), id: \.offset) { index, hist in
                        
                        if index < limit  {
                            HStack {
                                Image(selectedExercise == .scale ? "ScaleExercise" : "SustainExercise")
                                Spacer()
                                
                                VStack{
                                    Text(selectedExercise == .scale ? "ScaleExercise" : "SustainExercise")
                                        .font(.title2.bold())
                                        .foregroundStyle(selectedExercise == .scale ? .blue : .green)
                                        .frame(maxWidth : .infinity, alignment : .leading)
                                    
                                    Text("Exercise No : \(abs(self.values.count - index))")
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
                    
                    Button(action: {
                        limit += 5
                    }){
                        Text("Load more data")
                            .padding()
                    }
                }
                
            }
            .onAppear {
                //history?.deleteAll()
                var arr = [Int]()
                for val in history?.fetchAll(type : selectedExercise == .scale ? 0 : 1) ?? [] {
                    arr.append(Int(val.accuracy))
                }
                self.values = arr
                
                
                dataPoints = values.enumerated().map { ValuePoint(index: $0.offset + 1, value: $0.element) }
            }
            
        }
        .padding(.horizontal, 10)
       
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
    ContentView()
    //HistoryPage(history : .constant(nil))
}
