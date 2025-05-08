//
//  ContentView.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 29/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path : $path) {
            //Mic()
            //  WarmUpSessionScreen()
            HomePage(path : $path)
                .modelContainer(for : [UserProfile.self])
            .navigationDestination(for : String.self){ route in
                
                switch(route){
                case "warmup":
                    WarmUpPage(path : $path)
                case "exercise" :
                    ExercisePage(path : $path)
                case "vocaltest" :
                    GenderSelection(path: $path)
                        .modelContainer(for : [UserProfile.self])
                case "vtinstruction" :
                    VocalTestInstruction(path : $path)
                case "vtest1":
                    VocalTest(path : $path)
                        .modelContainer(for : [UserProfile.self])
                case "vtest2":
                    VocalTest(path : $path, type : 1)
                        .modelContainer(for : [UserProfile.self])
                case "vocalresult":
                    VocalResult(path : $path)
                        .modelContainer(for : [UserProfile.self])
                case "humming":
                    WarmUpSessionScreen()
                        .modelContainer(for : [UserProfile.self])
                case "liptrills":
                    WarmUpSessionScreen()
                        .modelContainer(for : [UserProfile.self])
                case "tonguetrill":
                    WarmUpSessionScreen()
                        .modelContainer(for : [UserProfile.self])
                case "breathing":
                    BreathingView()
                default:
                    HomePage(path : $path)
                        .modelContainer(for : [UserProfile.self])
                }
                
                
            
                
                
            }
        }
    }
}

#Preview {
    ContentView()
}
