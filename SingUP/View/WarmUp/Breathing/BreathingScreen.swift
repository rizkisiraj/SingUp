import SwiftUI

struct BreathingView: View {
    enum BreathingPhase: String {
        case inhale = "In"
        case hold = "Hold"
        case exhale = "Out"
    }

    struct Session {
        let holdDuration: Double?
    }
    
    @Binding var path: NavigationPath
    @State private var isFinished = false
    @State private var currentSessionIndex = 0
    @State private var phase: BreathingPhase = .inhale
    @State private var scales: [CGFloat] = [0.8, 0.8, 0.8]
    @State private var countdown: Int = 0
    @State private var timer: Timer?

    let inhaleDuration = 4.0
    let exhaleDuration = 4.0

    let sessions: [Session] = [
        Session(holdDuration: nil),
        Session(holdDuration: nil),
        Session(holdDuration: 5.0),
        Session(holdDuration: 10.0)
    ]

    let multipliers: [CGFloat] = [0.8, 1.0, 1.2]

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .foregroundStyle(Color.blue.opacity(Double(3 - i) * 0.2))
                        .frame(width: 200, height: 200)
                        .scaleEffect(scales[i])
                        .animation(.easeInOut(duration: animationDuration()), value: scales[i])
                }

                Circle()
                    .stroke(Color.putihAbu, lineWidth: 2)
                    .frame(width: 200, height: 200)

                VStack(spacing: 10) {
                    Text(phase.rawValue)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    // Countdown Timer Text
                    Text("\(countdown)")
                        .font(.title)
                        .foregroundColor(.white)
                        .opacity(countdown > 0 ? 1 : 0)
                }
            }

            Text("Make sure to use abdominal (diaphragmatic) breathing while standing up straight.")
                .multilineTextAlignment(.center)
                .font(.title2.bold())
                .padding(.horizontal, 40)
            
            Text("Session \(currentSessionIndex + 1) of \(sessions.count)")
                .foregroundColor(.gray)
                .font(.title2)

            Spacer()
        }
        .onAppear {
            startSession()
        }
    }

    func animationDuration() -> Double {
        switch phase {
        case .inhale: return inhaleDuration
        case .exhale: return exhaleDuration
        case .hold: return sessions[currentSessionIndex].holdDuration ?? 0
        }
    }

    func startCountdown(seconds: Int) {
        countdown = seconds
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer?.invalidate()
            }
        }
    }

    func startSession() {
        phase = .inhale
        startCountdown(seconds: Int(inhaleDuration))
        for i in 0..<scales.count {
            scales[i] = multipliers[i]
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + inhaleDuration) {
            if let hold = sessions[currentSessionIndex].holdDuration {
                phase = .hold
                startCountdown(seconds: Int(hold))
                DispatchQueue.main.asyncAfter(deadline: .now() + hold) {
                    startExhale()
                }
            } else {
                startExhale()
            }
        }
    }

    func startExhale() {
        phase = .exhale
        startCountdown(seconds: Int(exhaleDuration))
        for i in 0..<scales.count {
            scales[i] = 0.8
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + exhaleDuration) {
            if currentSessionIndex < sessions.count - 1 {
                currentSessionIndex += 1
                startSession()
            } else {
                phase = .exhale
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    path.append("warmupdone")
                }
            }
        }
    }
}


struct BreathingView_Previews: PreviewProvider {
    static var previews: some View {
        BreathingView(path : .constant(NavigationPath()))
    }
}

