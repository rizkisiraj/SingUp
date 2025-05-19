//
//  HomeMenu.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 08/05/25.
//

import SwiftUI

struct HomeMenu : Hashable {
    var title:String
    var path: String
    var image : String
    var description : String
    var color : Color
}

var homeMenus : [HomeMenu] = [
    HomeMenu(title : "Vocal Warm UP", path : "warmup", image : "VocalWarmUp", description : "Get your voice ready with quick and easy warm-ups to sing better, stronger, and safer.", color : Color("YellowWarmupCard")),
    HomeMenu(title : "Vocal Exercise", path : "exercise", image : "VocalExercise", description : "Get your voice ready with quick and easy vocal exercise to sing better, stronger, and safer.", color : Color("RedExerciseCard")),
    HomeMenu(title : "Re-Test Vocal Range", path : "vtinstruction", image : "VocalTest", description : "Let us know your vocal range with quick vocal range test and personalized your vocal training.", color : Color("GreenVocalTestCard")),
    
    ]
