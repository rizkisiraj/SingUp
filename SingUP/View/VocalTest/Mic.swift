//
//  Mic.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 04/05/25.
//

import SwiftUI

struct Mic: View {
    @StateObject var detector = FrequencyDetector()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Frekuensi Dominan:")
                .font(.headline)
            Text(String(format: "%.2f Hz", detector.frequency))
                .font(.system(size: 36, weight: .bold, design: .monospaced))
                .foregroundColor(.blue)
            
        }
        .padding()
    }
    
}
