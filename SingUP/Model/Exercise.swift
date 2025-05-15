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
    Exercise(title: "Scale", image : "ScaleExercise", imageLottie: "Scale Doremi", description: "Train your pitch accuracy and vocal agility by singing through scales smoothly and evenly, one note at a time.", shortDesc: "Practice Vocal Range", path : "scale"),
]
