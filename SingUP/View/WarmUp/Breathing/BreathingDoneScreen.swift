//
//  A.swift
//  SingUP
//
//  Created by Rizki Siraj on 08/05/25.
//

import SwiftUI

struct BreathingDoneScreen: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Well Done!")
                .font(.title)
                .fontWeight(.bold)
            Text("You have complete Breath Warm-Up")
                .padding(.top, 1)
            Spacer()
            Image(.breathDoneIcon)
            Spacer()
            Button {
                path.removeLast(path.count)
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            Button("Re-test the warm up", systemImage: "arrow.clockwise") {
                
            }
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
}


//struct BreathingDone_Previews: PreviewProvider {
//    static var previews: some View {
//        BreathingDoneScreen(.constant())
//    }
//}
