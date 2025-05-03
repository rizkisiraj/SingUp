//
//  ExercisePage.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI


struct ExercisePage: View {
    var body: some View {
        VStack{
            Spacer()
            Text("Vocal Exercise")
                .font(.title.bold())
                .frame(maxWidth : .infinity)
                .padding(.vertical , 10)
            
            Text("Choose your exercise")
                .font(.title3)
                .padding(.bottom, 50)
         
            
            GroupBox{
                HStack{
                    Image(systemName: "chart.line.flattrend.xyaxis")
                        .font(.title)
                        .padding()

                    Text("Sustain" )
                        .bold(true)
                        .font(.title)
                        .frame(maxWidth : .infinity, alignment : .leading)
                }
                
            }
            .padding(.horizontal , 20)
            
            GroupBox{
                HStack{
                    Image(systemName: "arrow.down.left.arrow.up.right")
                        .font(.title)
                        .padding()
                    
                    Text("Scale")
                        .bold(true)
                        .font(.title)
                        .frame(maxWidth : .infinity, alignment : .leading)
                }
               
            }
            .padding(.horizontal , 20)
            
            Spacer()
            
        }
        .toolbar{
        
        }
    }
}


#Preview{
    NavigationStack{
        ExercisePage()
    }
}
