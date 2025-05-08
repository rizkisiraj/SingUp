//
//  ScaleCompleted.swift
//  SingUP
//
//  Created by Surya on 08/05/25.
//

import SwiftUI

struct ScaleCompleted: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath // Binding to NavigationPath to control navigation
    var body: some View {
        VStack(spacing: 30) {
            Text("Amazing !")
                .font(.largeTitle)
                .padding(.top, 60)
            
            Image("ScaleTraining")
            
            Text("You’ve completed your Scale note exercise with steady breath control.")
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 8) {
                Text("Pitch\nAccuracy")
                    .font(.system(size: 16, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("30%")
                    .font(.system(size: 32, weight: .bold))
                
                Text("You are quite off-pitch")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: 130)
            .padding()
            .background(Color(.systemGray5).opacity(0.5))
            .cornerRadius(12)
            
            VStack(spacing: 10) {
                Button(action: {
                    path.removeLast(path.count)
                }) {
                    Text("Back to Home")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Button(action: {
                    dismiss()
                }) {
                    Label("re-test Vocal Scale Training", systemImage: "arrow.counterclockwise")
                        .foregroundColor(.blue)
                        .padding()
                }
                .buttonStyle(PlainButtonStyle())
            }
            

            Spacer()
        }
        .padding(.horizontal, 16) // Apply 16px horizontal padding to entire screen
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

//#Preview {
//    ScaleCompleted()
//}
