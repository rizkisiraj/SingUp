//
//  Exercise.swift
//  SingUP
//
//  Created by Surya on 08/05/25.
//

import SwiftUI

struct Exercise: Identifiable {
    let id = UUID()
    var title: String
    var image: String
    var imageLottie: String
    var description: String
    var shortDesc: String
    var path: String = ""
}

let listOfExercise: [Exercise] = [
    Exercise(title: "Scale", image : "ScaleExercise", imageLottie: "Scale Doremi", description: "Sing the “do-re-mi” scale ascending and descending smoothly. Focus on hitting each note clearly and staying on pitch. Take your time and listen carefully.", shortDesc: "Practice Vocal Range", path : "scale"),
]
