//
//  WarmUp.swift
//  SingUP
//
//  Created by Rizki Siraj on 07/05/25.
//
import SwiftUI


struct WarmUp {
    var title: String
    var image: ImageResource
    var description: String
    var path: String = ""
}

let listOfWarmUp: [WarmUp] = [
    WarmUp(title: "Breathing", image: .breathWarmUpIcon, description: "Breath by inhaling deeply, holding it briefly, and exhaling slowly to help your voice become stronger and more stable when singing."),
    WarmUp(title: "Humming", image: .hummningWarmUpIcon, description: "Warm up your voice by gently humming a comfortable note feel the vibrations in your face and stay relaxed as you ease into your singing."),
    WarmUp(title: "Lip Trills", image: .hummningWarmUpIcon, description: "Warm up your voice with lip trills by blowing air through relaxed lips while gliding through different pitches—great for breath control and vocal flexibility."),
    WarmUp(title: "Tongue Trills", image: .hummningWarmUpIcon, description: "Loosen up your articulation and breath support by doing tongue trills roll your ‘R’ sound while gliding through different pitches."),
]
