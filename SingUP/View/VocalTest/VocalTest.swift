//
//  VocalTest.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI


struct VocalTest: View {
    @State private var Num = 0
    
    var taskRepeater = TaskRepeater()
    
    func increment() {
        Num = (Num + 1)%100
    }
    
    
    var body: some View {
        Text("Sing Ahh \n as Lowest as u Can")
            .font(.title)
            .multilineTextAlignment(.center)
            .bold(true)
            .padding()
        
        HStack(spacing : 0){
                Text("\(Num - 2)")
                    .font(.title)
                    .padding()
                
                Text("\(Num - 1)")
                    .font(.title)
                    .padding()
                
                Text("\(Num)")
                    .font(.system(size: 60))
                    .bold(true)
                    .padding()
                
                
                Text("\(Num + 1)")
                    .font(.title)
                    .padding()
                
                Text("\(Num + 2)")
                    .font(.title)
                    .padding()
                
            }
            .onAppear{
                taskRepeater.tasks = increment
                taskRepeater.start()
            }
           
        Text("Hold for 2 seconds")
            
        
    }
        
}

#Preview{
    VocalTest()
}
