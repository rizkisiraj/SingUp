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
            List(listOfWarmUp) {warmUp in
                NavigationLink {
                    WarmUpGuideScreen(warmUp: warmUp)
                } label: {
                    HStack {
                        Image(warmUp.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50)
                        VStack(alignment: .leading) {
                            Text(warmUp.title)
                                .font(.title3)
                                .fontWeight(.bold)
                            Text(warmUp.shortDesc)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.leading)
                        
                    }
                    .padding(8)
                }
            }
        }
        .navigationTitle("Warm Up")
    }
}

#Preview{
    NavigationStack{
        WarmUpPage()

    }
}

