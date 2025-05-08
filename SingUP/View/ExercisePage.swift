//
//  ExercisePage.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI

struct ExercisePage: View {
    var items = [
        (systemIcon: "waveform", title: "Sustain", subtitle: "Long, steady notes", color: Color.red),
        (systemIcon: "stairs", title: "Scale", subtitle: "Practice vocal range", color: Color.blue)
    ]
    
    var body: some View {
        List {
            Section(header: Text("Choose Vocal Training")
                        .font(.title2)
                        .bold()
                        .padding(.top, 8)
                        .padding(.bottom, 8)) {
                ForEach(items, id: \.title) { item in
                    HStack {
                        Image(systemName: item.systemIcon) // SF Symbol icon on the left
                            .foregroundColor(item.color) // Apply specific color to each icon
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title) // Title text
                                .font(.headline)
                            Text(item.subtitle) // Subtitle text
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right") // Chevron on the right
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Vocal Exercise") // Inline mode centers the title in the navigation bar
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Button tapped")
                }) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
            }
        }
    }
}


#Preview{
    NavigationStack{
        ExercisePage()
    }
}
