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
    Exercise(title: "Sustain", image: .sustainTraining, description: "Sustain vocal training teaches you how to hold a note longer with steady sound and clear pitch. It helps you breathe better and keep your voice strong.", shortDesc: "Long, Steady notes", path:  "sustain"),
    Exercise(title: "Scale", image: .scaleTraining, description: "Train your pitch accuracy and vocal agility by singing through scales smoothly and evenly, one note at a time.", shortDesc: "Practice Vocal Range", path : "scale"),
]
