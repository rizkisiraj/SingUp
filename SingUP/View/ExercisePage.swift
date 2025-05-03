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
            GroupBox{
                Text("Sustain" )
                    .frame(maxWidth : .infinity, alignment : .leading)
            }
            .padding(.horizontal , 20)
            
            GroupBox{
                Text("Scale")
                    .frame(maxWidth : .infinity, alignment : .leading)
            }
            .padding(.horizontal , 20)
            
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
