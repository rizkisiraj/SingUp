//
//  Untitled.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//
import SwiftUI

struct WarmUpPage:View{
    @Binding var path : NavigationPath

    var body: some View{
        VStack{
            List(listOfWarmUp) {warmUp in
                NavigationLink(value: warmUp) {
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
            .navigationDestination(for: WarmUp.self) { warmUp in
                WarmUpGuideScreen(warmUp: warmUp, path: $path)
            }
        }
        .navigationTitle("Warm Up")
    }
}

#Preview{
    @Previewable @State var path = NavigationPath()

    NavigationStack{
        WarmUpPage(path : $path)

    }
}

