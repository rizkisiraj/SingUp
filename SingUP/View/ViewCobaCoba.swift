//
//  ViewCobaCoba.swift
//  SingUP
//
//  Created by Rizki Siraj on 12/05/25.
//

import Foundation
import SwiftUI

struct Note: Identifiable {
    let id = UUID()
    let noteNumber: Int
    let startTime: Double
    let velocity: Int
}

struct MIDIPianoRollView: View {

    var body: some View {
//        ScrollView {
//            ForEach(viewModel.notes) { note in
//                HStack {
//                    Text("🎵 Note \(note.noteNumber)")
//                    Spacer()
//                    Text("Start: \(note.startTime)")
//                    Text("Velocity: \(note.velocity)")
//                }
//                .padding()
//            }
//        }
        Text("Siraj")
            .onAppear {
                if let url = Bundle.main.url(forResource: "no name (1)", withExtension: "mid") {
                    loadMIDI(from: url)
                }
                
            }
    }
}

#Preview{
    MIDIPianoRollView()
}
