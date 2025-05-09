//
//  ContentView.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 29/04/25.
//

import SwiftUI
import AVFoundation

// MARK: PEMBATAS-------------------------

// MARK: HALAMAN PERTAMA
struct FirstScreen: View {
    @State private var showSplash = true
    @State private var navigateToSubView = false
    @State private var showSettingsAlert = false

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
                    OnboardingView(navigateToSubView: $navigateToSubView, showSettingsAlert: $showSettingsAlert)
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
    }
    
    // Helper function to check if microphone permission is granted
    func hasGrantedPermission() -> Bool {
        return UserDefaults.standard.bool(forKey: "MicrophonePermissionGranted")
    }
}

// This is onboarding Screen
struct OnboardingView: View {
    @Binding var navigateToSubView: Bool
    @Binding var showSettingsAlert: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 32) {
                Text("Access to your\nMicrophone")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.semibold)

                Image(systemName: "microphone.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(12)
                    .foregroundColor(.blue)

                Text("in SingUp you can:")
                    .font(.title)
                    .fontWeight(.semibold)

                VStack(alignment: .leading, spacing: 0) {
                    Text("• Identify your Vocal Type")
                    Text("• Guided warm-up Breath")
                    Text("• Train your pitch control")
                    Text("• See progress through your train")
                }
                .fontWeight(.semibold)

                Text("This app requires microphone access to help you identify your vocal type and practice pitch accuracy.")
                    .multilineTextAlignment(.center)

                (
                    Text("By tapping ") +
                    Text("Continue").bold() +
                    Text(", you ") +
                    Text("agree").bold() +
                    Text(" to allow the app to use your ") +
                    Text("microphone").bold() +
                    Text(".")
                )
                .multilineTextAlignment(.center)
                .padding()
                // MARK: NAVIGATE TO SubView
                .navigationDestination(isPresented: $navigateToSubView) {
                    ContentView()
                }

                Button("Continue") {
                    if #available(iOS 17.0, *) {
                        AVAudioApplication.requestRecordPermission { granted in
                            DispatchQueue.main.async {
                                if granted {
                                    UserDefaults.standard.set(true, forKey: "MicrophonePermissionGranted") // Save permission state
                                    print("Microphone access granted")
                                    navigateToSubView = true
                                } else {
                                    print("Microphone access denied")
                                    showSettingsAlert = true
                                }
                            }
                        }
                    } else {
                        AVAudioSession.sharedInstance().requestRecordPermission { granted in
                            DispatchQueue.main.async {
                                if granted {
                                    UserDefaults.standard.set(true, forKey: "MicrophonePermissionGranted") // Save permission state
                                    print("Microphone access granted")
                                    navigateToSubView = true
                                } else {
                                    print("Microphone access denied")
                                    showSettingsAlert = true
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .alert("Microphone Access Required", isPresented: $showSettingsAlert) {
                    Button("Go to Settings") {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Please enable microphone access in Settings to continue using voice features.")
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: Splash Screen

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Image("SingUpIcon")
            }
        }
    }
}

// MARK: PEMBATAS-------------------------

struct ContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path : $path) {
            //Mic()
            //  WarmUpSessionScreen()
            HomePage(path : $path)
                .modelContainer(for : [UserProfile.self])
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
                        .modelContainer(for : [UserProfile.self])
                } else if route == "scale"{
                    ScaleTraining(path: $path)
                        .modelContainer(for : [UserProfile.self])
                } else if route == "sustain"{
                    SustainTraining(path: $path)
                        .modelContainer(for : [UserProfile.self])
                } else{
                    //Mic()
                    HomePage(path : $path)
                        .modelContainer(for : [UserProfile.self])
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the back button in SubView
    }
}

#Preview {
    ContentView()
}
