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
            HomePage(path : $path)
            .navigationDestination(for : String.self){ route in
                if route == "warmup" {
                    WarmUpPage()
                } else if route == "exercise" {
                    ExercisePage()
                } else if route == "vocaltest"{
                    GenderSelection(path: $path)
                } else if route == "vtinstruction"{
                    VocalTestInstruction(path : $path)
                }  else if route == "vtest1"{
                    VocalTest()
                }
                
                
            }
        }
    }
}

#Preview {
    ContentView()
}
