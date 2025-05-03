//
//  VocalTest.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI


struct VocalTest: View {
    @Binding public var path : NavigationPath
    @State private var Num = 0
    public var type =  0
    
    var taskRepeater = TaskRepeater()
    
    func increment() {
        Num = (Num + 1) % ( chord.count - 1 )
    }
    
    func reScale(range : Int)-> Int{
        return (chord.count + Num + range  ) % chord.count;
    }
    
    
    var body: some View {
        Text("Sing Ahh \n as \(type == 0 ? "Lowest" : "Highest") as u Can")
            .font(.title)
            .multilineTextAlignment(.center)
            .bold(true)
            .padding()
            .padding(.bottom, 30)
        
        
        Image(systemName: "arrowshape.down.fill")
            .frame(maxWidth : .infinity, alignment : .center)
        
        Divider()
            .padding(.horizontal, 20)
        
        HStack(spacing : 0){
                Text("\(chord[reScale(range : -2)])")
                    .font(.title)
                    .padding()
                
                Text("\(chord[reScale(range : -1)])")
                    .font(.title)
                    .padding()
                

                Text("\(chord[Num])")
                    .font(.system(size: 60))
                    .bold(true)
                    .multilineTextAlignment(.center)
                    .padding()
                
                
                Text("\(chord[reScale(range : 1)])")
                    .font(.title)
                    .padding()
                
                Text("\(chord[reScale(range : 2)])")
                    .font(.title)
                    .padding()
                
            }
            .onAppear{
                taskRepeater.tasks = increment
                taskRepeater.interval = 500
                taskRepeater.start()
            }
           
        Divider()
            .padding(.horizontal, 20)
        
        Text("Hold for 2 seconds")
            .padding()
        
        Button(
            action : {
                path.append(type == 0 ? "vtest2" : "vocalresult")
            }
        ){
            Text("Lanjut")
                .foregroundStyle(.white)
        }
        .padding(10)
        .padding(.horizontal, 40)
        .background(
            RoundedRectangle(cornerRadius: 10).fill(Color.blue)
        )
            
        
    }
        
}

#Preview{
    @Previewable @State var path = NavigationPath()
    ContentView()
}
