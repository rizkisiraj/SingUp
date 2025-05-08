//
//  VocalTestInstruction.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI

struct VocalTestInstruction : View{
    @Binding var path : NavigationPath

    var body : some View{
        VStack(){
            
            Text("Vocal Range Test")
                .font(.title.bold())
                .bold(true)
            
            Image("VocalRangeTestIcon")
                .resizable()
                .frame(width: 300, height: 300)
                .padding()
                .offset(x : 20)
            
            Text("Discover your vocal range by singing 'Ahh' as the notes go higher and lower stop when you reach the highest or lowest note you can sing comfortably.   ")
                .multilineTextAlignment(.center)
                .frame(alignment : .center)
                .font(.caption)
                .padding(.horizontal, 50)
            
            Button(action: {path.append("vtest1")}){
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth : .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    
            }
            .padding(50)
            .onTapGesture {
                
            }
                
        }
    }
}

#Preview{
    @Previewable @State var path = NavigationPath()

    VocalTestInstruction(path : $path)
}
