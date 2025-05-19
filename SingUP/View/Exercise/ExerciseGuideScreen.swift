//
//  ExerciseGuideScreen.swift
//  SingUP
//
//  Created by Surya on 08/05/25.
//
import Lottie
import SwiftUI

struct ExerciseGuideScreen: View {
    var exercise: Exercise
    @Binding var path : NavigationPath
    
    var body: some View {
        VStack {
            Spacer()
            Text(exercise.title)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
//            Image(exercise.image)
            LottieView(animation: .named(exercise.imageLottie))
                .looping()
            Spacer()
            Text(exercise.description)
                .multilineTextAlignment(.center)
                
            Spacer()
            Button {
                path.append(exercise.path)
            } label: {
                Text("Start")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            Spacer()
        }
        .padding()
    }
}

#Preview{
    @Previewable @State var path = NavigationPath()

    NavigationStack{
        ExerciseGuideScreen(
            exercise: listOfExercise[0],
            path : $path
        )
    }
}
