//
//  A.swift
//  SingUP
//
//  Created by Rizki Siraj on 08/05/25.
//

import SwiftUI

struct WarmUpDoneScreen: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Well Done!")
                .font(.title)
                .fontWeight(.bold)
            Text("You have complete \(warmup.title) Warm-Up")
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
                path.removeLast(path.count)
                path.append(warmup.path)
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

#Preview {
    WarmUpDoneScreen(path: .constant(NavigationPath()))
}
