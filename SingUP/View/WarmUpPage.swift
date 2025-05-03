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
            GroupBox{
                Text("Breath" )
                    .frame(maxWidth : .infinity, alignment : .leading)
            }
            .padding(.horizontal , 20)
            
            GroupBox{
                Text("Humming")
                    .frame(maxWidth : .infinity, alignment : .leading)
            }
            .padding(.horizontal , 20)
            
            GroupBox{
                Text("Lip Drill")
                    .frame(maxWidth : .infinity, alignment : .leading)
            }
            .padding(.horizontal , 20)
            
            GroupBox{
                Text("Tongue Drill")
                    .frame(maxWidth : .infinity, alignment : .leading)
            }
            .padding(.horizontal , 20)
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

