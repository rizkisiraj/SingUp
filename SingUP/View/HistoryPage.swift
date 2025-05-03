//
//  HistoryPage.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import Charts
import SwiftUI

struct historyData : Identifiable {
    var id : UUID = UUID()
    var name : String
    var accuracy : Double
}

struct HistoryPage: View {
    
    var data : [historyData] = [
        .init(name: "A", accuracy: 70.0),
        .init(name: "B", accuracy: 80.0),
        .init(name: "C", accuracy: 90.0),
        .init(name: "D", accuracy: 90.0),
        .init(name: "E", accuracy: 90.0),
        .init(name: "F", accuracy: 90.0),
        .init(name: "G", accuracy: 90.0),
        .init(name: "H", accuracy: 90.0),
        .init(name: "I", accuracy: 90.0),
        .init(name: "J", accuracy: 90.0),
    ]
    
    var body: some View {
        
        Text("HistoryPage")
            .font(.largeTitle)
            .multilineTextAlignment(.leading)
            .frame(maxWidth : .infinity, alignment : .leading)
            .padding(20)
            .bold(true)
            .padding(.bottom , 50)
        
        Chart{
            ForEach(data, id: \.id) { item in
                LineMark(
                    x : .value("Name", item.name) ,
                    y : .value("Accuracy", item.accuracy)
                )
            }
            
        }
        .frame(maxHeight : 200)
        .padding(.horizontal, 20)
        
        ScrollView{
            ForEach(data, id: \.id) { item in
                GroupBox{
                    HStack{
                        Image(systemName: "microphone.circle.fill")
                            .font(.system(size : 50))
                        
                        
                        VStack{
                            Text("Sustain")
                                .font(.title)
                                .frame(maxWidth : .infinity , alignment : .leading)
                            
                            Text("00:50")
                                .font(.title2)
                                .frame(maxWidth : .infinity , alignment : .leading)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()

                        VStack(alignment : .leading){
                            Text("\(item.accuracy.formatted(.number.precision(.fractionLength(0))))%")
                                .font(.title.bold())
                               
                            Text("Accuracy")
                                .font(.caption)
                        }
                    }
                }
            }
            
            
        }
        .padding()
        
        Spacer()
        
    }
}


#Preview {
    HistoryPage()
}
