//
//  ContentView.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 29/04/25.
//

import SwiftUI
import AVFoundation

// MARK: PEMBATAS-------------------------




// MARK: PEMBATAS-------------------------

struct ContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path : $path) {
            //Mic()
            //  WarmUpSessionScreen()
            HomePage(path : $path)
                .modelContainer(for : [UserProfile.self, VocalTraining.self])
            .navigationDestination(for : String.self){ route in
                if route == "warmup" {
                    WarmUpPage(path : $path)
                } else if route == "exercise" {
                    ExercisePage(path : $path)
                } else if route == "vocaltest"{
                    GenderSelection(path: $path)
                        .modelContainer(for : [UserProfile.self])
                } else if route == "vtinstruction"{
                    VocalTestInstruction(path : $path)
                } else if route == "vtest1"{
                    VocalTest(path : $path)
                        .modelContainer(for : [UserProfile.self])
                } else if route == "vtest2"{
                    VocalTest(path : $path, type : 1)
                        .modelContainer(for : [UserProfile.self])
                } else if route == "warmupdone"{
                    BreathingDoneScreen(path: $path)
                } else if route == "vocalresult"{
                    VocalResult(path : $path)
                        .modelContainer(for : [UserProfile.self])
                } else if route == "breathing"{
                    BreathingView(path: $path)
                } else if route == "warmupdone" {
                    BreathingView(path: $path)
                } else if route == "humming"{
                    WarmUpSessionScreen()
                        .modelContainer(for : [UserProfile.self])
                } else if route == "liptrills"{
                    WarmUpSessionScreen()
                        .modelContainer(for : [UserProfile.self])
                } else if route == "tonguetrill"{
                    WarmUpSessionScreen()
                        .modelContainer(for : [UserProfile.self, VocalTraining.self])
                } else if route == "scale"{
                    ScaleTraining(path: $path)
                        .modelContainer(for : [UserProfile.self, VocalTraining.self])
                } else{
                    //Mic()
                    HomePage(path : $path)
                        .modelContainer(for : [UserProfile.self, VocalTraining.self])
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the back button in SubView
    }
}

#Preview {
    ContentView()
}
