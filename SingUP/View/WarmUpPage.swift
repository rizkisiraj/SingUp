//
//  Untitled.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//
import SwiftUI

struct WarmUpPage:View{
    
    var body: some View{
        VStack{
            Spacer()
            Text("Vocal Wram Up")
                .font(.title.bold())
                .frame(maxWidth : .infinity)
                .padding(.vertical , 10)
            
            Text("Choose your warm up")
                .font(.title3)
                .padding(.bottom, 50)
            
            GroupBox{
                HStack{
                    Image(systemName: "lungs.fill")
                        .font(.title)
                        .padding()
                    Text("Breath" )
                        .frame(maxWidth : .infinity, alignment : .leading)
                }
            }
            .padding(.horizontal , 20)
            
            GroupBox{
                HStack{
                    Image(systemName: "person.wave.2.fill")
                        .font(.title)
                        .padding()
                    Text("Humming")
                        .frame(maxWidth : .infinity, alignment : .leading)
                }
            }
            .padding(.horizontal , 20)
            
            GroupBox{
                HStack{
                    Image(systemName: "mouth.fill")
                        .font(.title)
                        .padding()
                    Text("Lip Drill")
                        .frame(maxWidth : .infinity, alignment : .leading)
                }
            }
            .padding(.horizontal , 20)
            
            GroupBox{
                HStack{
                    Image(systemName: "mouth")
                        .font(.title)
                        .padding()
                    Text("Tongue Drill")
                        .frame(maxWidth : .infinity, alignment : .leading)
                }
            }
            .padding(.horizontal , 20)
            
            Spacer()
        }
        .toolbarRole(.navigationStack)
        .toolbar{
        }
    }
}

#Preview{
    NavigationStack{
        WarmUpPage()

    }
}

