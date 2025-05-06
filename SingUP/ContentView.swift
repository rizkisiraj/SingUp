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
            HomePage(path : $path)
                .modelContainer(for : [UserProfile.self])
            .navigationDestination(for : String.self){ route in
                if route == "warmup" {
                    WarmUpPage()
                } else if route == "exercise" {
                    ExercisePage()
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
                } else if route == "vocalresult"{
                    VocalResult(path : $path)
                        .modelContainer(for : [UserProfile.self])
                }else{
                    //Mic()
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
