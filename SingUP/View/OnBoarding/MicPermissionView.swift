//
//  MicPermissionView.swift
//  SingUP
//
//  Created by Surya on 11/05/25.
//

import SwiftUI

// MARK: HALAMAN PERTAMA
struct MicPermissionView: View {
    @State private var showSplash = true
    @State private var navigateToSubView = false
    @State private var showSettingsAlert = false
    
    @State private var reloadID = UUID() // <- Add this

    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen()
                    .transition(.opacity)
            } else {
                // Check if user already granted microphone permission
                if hasGrantedPermission() {
                    ContentView()  // Directly show SubView if permission is granted
                } else {
                    OnboardingView(navigateToSubView: $navigateToSubView, showSettingsAlert: $showSettingsAlert, reloadID: $reloadID)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
        .id(reloadID) // <- Add this to re-render the whole view
    }
    
    // Helper function to check if microphone permission is granted
    func hasGrantedPermission() -> Bool {
        return UserDefaults.standard.bool(forKey: "MicrophonePermissionGranted")
    }
}
