//
//  OnboardingView.swift
//  SingUP
//
//  Created by Surya on 11/05/25.
//

import SwiftUI
import AVFoundation

// This is onboarding Screen
struct OnboardingView: View {
    @Binding var navigateToSubView: Bool
    @Binding var showSettingsAlert: Bool
    
    @Binding var reloadID: UUID // <- New binding

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
                                    //navigateToSubView = true
                                    
                                    // pake di branch onboarding
                                    UserDefaults.standard.set(true, forKey: "MicrophonePermissionGranted")
                                    reloadID = UUID() // Trigger view reload back to SplashScreen
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
