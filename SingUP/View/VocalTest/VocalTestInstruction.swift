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
            
            Text("Instruksi")
                .font(.title)
                .bold(true)
            
            Image(systemName: "photo")
                .font(.system(size: 200))
                .padding()
            
            Text("Baca instruksi berikut untuk memulai test vocal range anda ")
                .multilineTextAlignment(.center)
                .frame(alignment : .center)
                .padding(.horizontal, 50)
            
            Button(action: {path.append("vtest1")}){
                Text("Start Test")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .onTapGesture {
                
            }
                
        }
    }
}

#Preview{
    @Previewable @State var path = NavigationPath()

    VocalTestInstruction(path : $path)
}
