//
//  WarmUp.swift
//  SingUP
//
//  Created by Rizki Siraj on 07/05/25.
//
import SwiftUI


struct WarmUp: Identifiable {
    let id = UUID()
    var title: String
    var image: ImageResource
    var description: String
    var shortDesc: String
    var path: String = ""
}

let listOfWarmUp: [WarmUp] = [
    WarmUp(title: "Breathing", image: .breathWarmUpIcon, description: "Breath by inhaling deeply, holding it briefly, and exhaling slowly to help your voice become stronger and more stable when singing.", shortDesc: "Control your breathing"),
    WarmUp(title: "Humming", image: .hummningWarmUpIcon, description: "Warm up your voice by gently humming a comfortable note feel the vibrations in your face and stay relaxed as you ease into your singing.", shortDesc: "Warm up your voice softly"),
    WarmUp(title: "Lip Trills", image: .lipThrillsWarmUpIcon, description: "Warm up your voice with lip trills by blowing air through relaxed lips while gliding through different pitches—great for breath control and vocal flexibility.", shortDesc: "Loosen your tongue muscles"),
    WarmUp(title: "Tongue Trills", image: .tongueThrillsWarmUpIcon, description: "Loosen up your articulation and breath support by doing tongue trills roll your ‘R’ sound while gliding through different pitches.", shortDesc: "Relax your lips and airflow"),
]
