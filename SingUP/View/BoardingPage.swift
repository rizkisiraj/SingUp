//
//  BoardingPage.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 06/05/25.
//

import SwiftUI

struct BoardingPage: View {
    @State var checked = false
    
    var body: some View {
        Text("Welcome to SingUP")
            .font(.largeTitle.bold())
        
        Text("In SingUP you can :")
            .font(.title2)
            .padding()
        
        Text("● Identify your vocal range ")
            .padding(.horizontal, 50)
            .frame(maxWidth : .infinity, alignment : .leading)
        Text("● Train your pitch control ")
            .padding(.horizontal, 50)
            .frame(maxWidth : .infinity, alignment : .leading)
        Text("● See your progress of training ")
            .padding(.horizontal, 50)
            .frame(maxWidth : .infinity, alignment : .leading)
            .padding(.bottom, 20)
        
        Text("Our App requires access to your device's microphone to provide core features such as voice input and audio recording.")
            .font(.subheadline)
            .padding(.horizontal, 28)
            .multilineTextAlignment(.leading)

        
        HStack(alignment : .top){
            Text("●")
                .font(.subheadline)

            Text("Purpose: We use the microphone solely for track your vocal type and to guide you throught vocal exercise.")
                .font(.subheadline)
        }
        .padding(.horizontal, 30)

        HStack(alignment : .top){
            Text("●")
                .font(.subheadline)

            Text("Data Usage: “We do not store or share your audio recordings.”")
                .font(.subheadline)
        }
        .padding(.horizontal, 30)

       
        
        Text("Welcome to SingUp. By downloading or using our application (“SingUp”), you agree to these Terms and Conditions (“Terms”). Please read them carefully.")
            .font(.caption)
            .multilineTextAlignment(.center)
            .padding()
        
        HStack(){
            Button(action :
                    {
                checked = !checked
            }){
                ZStack{
                    Circle()
                        .fill(checked ? .blue : .gray)
                        .frame(maxWidth : 20)
                    Image(systemName : "checkmark")
                        .foregroundStyle(.white)
                        .font(.caption)
                }
                
                    
            }
            Text("i have read and i accept SingUp terms and use")
                .font(.caption)
        }
        .padding()
        
        Button(action :
                {
            
        }){
            Text("Continue")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth : .infinity)
                .background(Color.blue)
                .cornerRadius(10)


        }
        .padding(.horizontal, 30)
        

    }
}

#Preview{
    BoardingPage()
}
