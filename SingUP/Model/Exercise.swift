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
    var image: ImageResource
    var description: String
    var shortDesc: String
    var path: String = ""
}

let listOfExercise: [Exercise] = [
    Exercise(title: "Sustain", image: .scaleTraining, description: "Put description here", shortDesc: "Long, Steady notes", path:  "sustain"),
    Exercise(title: "Scale", image: .vocalExercise, description: "Train your pitch accuracy and vocal agility by singing through scales smoothly and evenly, one note at a time.", shortDesc: "Practice Vocal Range", path : "scale"),
]
