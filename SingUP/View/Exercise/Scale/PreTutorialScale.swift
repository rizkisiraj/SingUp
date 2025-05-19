//
//  PreTutorialScale.swift
//  SingUP
//
//  Created by Rizki Siraj on 15/05/25.
//

import SwiftUI
import AVFoundation


struct WelcomeChatOverlay: View {
    var onDismiss: () -> Void
    @State private var introPlayer: AVAudioPlayer? = nil
    @State private var isCountingDown = false
    @State private var countdownNumber = 3


    var body: some View {
        if isCountingDown {
            Text("\(countdownNumber)")
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.blue)
                                .transition(.scale)
                                .animation(.easeInOut, value: countdownNumber)
        } else {
            RotatingChatOverlay(
                    bubbles: [
                        "Hi, welcome to your first exercise!",
                            "The scale training is to train your vocal control.",
                            "In this exercise, you will sing Do, Re, Mi like this for 4 times.",
                            "As you sing, the blue indicator on the left will move up and down based on your vocal pitch try to match that with the note rectangle coming from the right.",
                            "Make sure to use headphones and find quiet spot for better vocal precision.",
                    ],
                    bubbleDurations: [3.5, 3.5, 16.5, 8.5, 5.5],
                    onFinished: {
                        stopIntroAudio()
                        startCountdown()
    //                    showWelcomeOverlay = false
                    },
                    onBubbleChange: { index in
                        if index == 0 {
                            playIntroAudio()
                        }
                    }
                )

        }
            }
    
    func playIntroAudio() {
        guard let url = Bundle.main.url(forResource: "intro1", withExtension: "mp3") else { return }
        do {
            introPlayer = try AVAudioPlayer(contentsOf: url)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                introPlayer?.play()
            }
        } catch {
            print("Failed to play intro audio: \(error)")
        }
    }

    func stopIntroAudio() {
        introPlayer?.stop()
        introPlayer = nil
    }
    
    func startCountdown() {
            isCountingDown = true
            countdownNumber = 3

            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if countdownNumber > 1 {
                    countdownNumber -= 1
                } else {
                    timer.invalidate()
                    isCountingDown = false
                    onDismiss()  // trigger parent to close overlay and start latihan
                }
            }
        }

}


struct RotatingChatOverlay: View {
    let bubbles: [String]
    let bubbleDurations: [Double]
    var onFinished: () -> Void
    var onBubbleChange: ((Int) -> Void)? = nil
    
    @State private var currentIndex = 0
    @State private var timer: Timer? = nil
    @State private var timerActive = true
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(bubbles[currentIndex])
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(radius: 5)
                )
                .padding()
                .animation(.easeInOut, value: currentIndex)
            
            if !timerActive {
                Button("Start Exercise") {
                    onFinished()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding()
                .transition(.opacity)
            }
        }
        .onAppear {
            onBubbleChange?(currentIndex)
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: bubbleDurations[currentIndex], repeats: false) { _ in
            if currentIndex < bubbles.count - 1 {
                currentIndex += 1
                onBubbleChange?(currentIndex)
                startTimer() // restart timer for next bubble
            } else {
                timerActive = false
                timer?.invalidate()
            }
        }
    }
}

//#Preview {
//    WelcomeChatOverlay(onDismiss: {})
//}
