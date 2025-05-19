//
//  ExercisePage.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI

struct ExercisePage: View {
    @Binding var path : NavigationPath

    var body: some View{
        VStack{
            List(listOfExercise) {exercise in
                NavigationLink {
                    ExerciseGuideScreen(exercise: exercise, path : $path)
                } label: {
                    HStack {
                        Image(exercise.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50)
                        VStack(alignment: .leading) {
                            Text(exercise.title)
                                .font(.title3)
                                .fontWeight(.bold)
                            Text(exercise.shortDesc)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.leading)
                        
                    }
                    .padding(8)
                }
            }
        }
        .navigationTitle("Vocal Training")
    }
}


#Preview{
    @Previewable @State var path = NavigationPath()

    NavigationStack{
        ExercisePage(path : $path)

    }
}
