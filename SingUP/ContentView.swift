//
//  ContentView.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 29/04/25.
//

import SwiftUI
import SwiftData
import AVFoundation

// MARK: PEMBATAS-------------------------




// MARK: PEMBATAS-------------------------

var warmup:WarmUp = listOfWarmUp[0]

struct ContentView: View {
    @State private var path = NavigationPath()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.modelContext) var context
    @Query var userProfile : [UserProfile]
    @State var history : History?
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if hasCompletedOnboarding {
                    HomePage(path: $path)
                } else {
                    GenderSelection(path: $path)
                        .onAppear {
                            if userProfile.first == nil{
                                let newProf = UserProfile(
                                    gender : "-",
                                    lowestFrequency: 0,
                                    highestFrequency: 0, hasScale: false
                                )
                                context.insert(newProf)
                            }
                        }
                }
            }
            .navigationDestination(for: String.self) { route in
                switch route {
                case "warmup":
                    WarmUpPage(path: $path)
                case "exercise":
                    ExercisePage(path: $path)
                case "vocaltest":
                    GenderSelection(path: $path)
                case "vtinstruction":
                    VocalTestInstruction(path: $path)
                case "sustain":
                    SustainTraining(path: $path)
                case "vtest1":
                    VocalTest(path: $path)
                case "vtest2":
                    VocalTest(path: $path, type: 1)
                case "warmupdone":
                    BreathingDoneScreen(path: $path)
                case "vocalresult":
                    VocalResult(path: $path)
                case "breathing":
                    BreathingView(path: $path)
                case "humming", "liptrills", "tonguetrill":
                    WarmUpSessionScreen(path: $path)
                case "scale":
                    ScaleTraining(path: $path)
                case "home":
                    HomePage(path: $path)
                default:
                    HomePage(path: $path)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            if userProfile.first == nil{
                let newProf = UserProfile(
                    gender : "-",
                    lowestFrequency: 0,
                    highestFrequency: 0, hasScale: false
                )
                context.insert(newProf)
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
