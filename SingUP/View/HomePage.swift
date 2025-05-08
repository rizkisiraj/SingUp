//
//  HomePage.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI
import SwiftData

struct HomePage:View{
    @Binding var path : NavigationPath
    @State var page : Int = 0
    @Query var userProfile : [UserProfile]
    @State var freq : [Int] = [0, 9999]
    var vocalRange = VocalRange()
    @Environment(\.modelContext) var context
    
    var body: some View{
        VStack{
            if page == 0 {
                ScrollView{
                    VStack(alignment : .leading, spacing : 0){
                        
                        Text("Your Vocal Range")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .bold(true)
                            .frame(maxWidth : .infinity, alignment : .center)
                            .padding(.bottom , 10)
                            .padding(.top, 50)
                        
                        Image(systemName: "microphone.circle.fill")
                            .multilineTextAlignment(.center)
                            .font(.system(size : 100))
                            .frame(maxWidth : .infinity, alignment : .center)
                        
                        
                        Text(vocalRange.getVocalType(lowFreq: freq[0], highFreq: freq[1]))
                            .font(.largeTitle)
                            .bold(true)
                            .frame(maxWidth : .infinity, alignment : .center)
                            .padding(.bottom , 0)
                            .padding(.top, 20)
                        
                        Text("\(getChordString(frequency : freq[0])) - \(getChordString(frequency : freq[1]))")
                            .font(.title3)
                            .bold(true)
                            .frame(maxWidth : .infinity, alignment : .center)
                            .padding(.bottom , 70)
                            .padding(.top, 10)
                        
                        GroupBox{
                            HStack{
                                Image(systemName : "waveform")
                                    .font(.title)
                                    .padding(.leading, 10)

                                Text("Vocal WarmUp")
                                    .multilineTextAlignment(.leading)
                                    .font(.title2)
                                    .bold(true)
                                    .frame(maxWidth : .infinity, alignment : .leading)
                                    .padding(.vertical, 20)
                                    .padding(.horizontal, 10)
                            }
                            
                            
                        }
                        .onTapGesture {
                            path.append("warmup")
                        }
                        .padding()
                        
                        GroupBox{
                            HStack{
                                Image(systemName : "music.microphone")
                                    .font(.title)
                                    .padding(.leading, 10)
                                
                                Text("Vocal Excercise")
                                    .multilineTextAlignment(.leading)
                                    .font(.title2)
                                    .bold(true)
                                    .frame(maxWidth : .infinity, alignment : .leading)
                                    .padding(.vertical, 20)
                                    .padding(.horizontal, 10)
                            }
                            
                        }
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            path.append("exercise")
                        }
                        
                        Button(action :  {
                            if let user = userProfile.first{
                                print(user.gender)
                                if user.gender == "Male" || user.gender == "Female"{
                                    path.append("vtinstruction")
                                    return;
                                }
                                path.append("vocaltest")
                            }
                            
                        }){
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                            Text("Re-Test Your Range")
                        }
                        .frame(maxWidth : .infinity, alignment : .center)
                        .padding(.vertical , 50)
                        
                    }
                }
                .onAppear(){
                    if let prof = userProfile.first{
                        freq = [Int(prof.lowestFrequency), Int(prof.highestFrequency)]
                    }else{
                        var newProf = UserProfile(
                            gender : "-",
                            lowestFrequency: 0,
                            highestFrequency: 0
                        )
                        context.insert(newProf)
                    }
                }
            }else{
                HistoryPage()
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
                Button(action: {
                    page = 0
                }){
                    VStack{
                        Image(systemName: "house.fill")
                            .foregroundStyle(page == 0 ? .blue  : .gray)
                        Text("Profile")
                            .foregroundStyle(page == 0 ? .blue  : .gray)

                    }
                }
            }
            
            ToolbarItem(placement: .bottomBar){
                Spacer()
            }
            
            ToolbarItem(placement: .bottomBar){
                Button(action: {
                    page = 1
                }){
                    VStack{
                        Image(systemName: "clock.fill")
                            .foregroundStyle(page == 1 ? .blue  : .gray)

                        Text("History")
                            .foregroundStyle(page == 1 ? .blue  : .gray)

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
