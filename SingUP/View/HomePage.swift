//
//  HomePage.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI

struct HomePage:View{
    @Binding var path : NavigationPath
    
    var body: some View{
        //Pake scroll view biar kaga over
        ScrollView{
            VStack(alignment : .leading, spacing : 0){
                
                Text("Your Vocal Range")
                    .font(.title2)
                    .bold(true)
                    .frame(maxWidth : .infinity, alignment : .center)
                    .padding(.bottom , 10)
                    .padding(.top, 50)
                Text("Tenor")
                    .font(.largeTitle)
                    .bold(true)
                    .frame(maxWidth : .infinity, alignment : .center)
                    .padding(.bottom , 0)
                    .padding(.top, 20)
                
                Text("C3 - E5")
                    .font(.title3)
                    .bold(true)
                    .frame(maxWidth : .infinity, alignment : .center)
                    .padding(.bottom , 100)
                    .padding(.top, 10)
                
                GroupBox{
                    Text("Vocal WarmUp")
                        .multilineTextAlignment(.leading)
                        .font(.title2)
                        .bold(true)
                        .frame(maxWidth : .infinity, alignment : .leading)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 10)

                }
                .onTapGesture {
                    path.append("warmup")
                }
                .padding()
                
                GroupBox{
                    Text("Vocal Excercise")
                        .multilineTextAlignment(.leading)
                        .font(.title2)
                        .bold(true)
                        .frame(maxWidth : .infinity, alignment : .leading)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 10)

                }
                .padding(.horizontal, 20)
                .onTapGesture {
                    path.append("exercise")
                }
                
                Button(action :  {
                    path.append("vocaltest")
                }){
                    Image(systemName: "play.fill")
                        .font(.title2)
                    Text("Re-Test Your Range")
                }
                .frame(maxWidth : .infinity, alignment : .center)
                .padding(.vertical , 50)
                
            }
        }
        .toolbarRole(.navigationStack)
        //Toolbar untuk navigasi
        //Pake Native ToolBar
        .toolbar{
            ToolbarItem(placement: .bottomBar){
                Spacer()
            }
            
            ToolbarItem(placement: .bottomBar){
                Button(action: {}){
                    VStack{
                        Image(systemName: "house.fill")
                        Text("Profile")
                    }
                }
            }
            
            ToolbarItem(placement: .bottomBar){
                Spacer()
            }
            
            ToolbarItem(placement: .bottomBar){
                Button(action: {}){
                    VStack{
                        Image(systemName: "clock.fill")
                        Text("Profile")
                    }
                }
            }
            
            ToolbarItem(placement: .bottomBar){
                Spacer()
            }
        }
        .frame(maxWidth : .infinity, maxHeight : .infinity)
        
    }
    
    
}



#Preview {
    @Previewable @State var path = NavigationPath()
    HomePage(path : $path )
}
