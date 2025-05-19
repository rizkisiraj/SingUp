//
//  WarmUp.swift
//  SingUP
//
//  Created by Rizki Siraj on 07/05/25.
//
import SwiftUI


struct WarmUp: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var image: ImageResource
    var description: String
    var shortDesc: String
    var path: String = ""
}

let listOfWarmUp: [WarmUp] = [
    WarmUp(title: "Breathing", image: .breathWarmUpIcon, description: "Breath by inhaling deeply, holding it briefly, and exhaling slowly to help your voice become stronger and more stable when singing.", shortDesc: "Control your breathing", path:  "breathing")
]
