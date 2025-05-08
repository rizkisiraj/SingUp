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
                        
                        Text("Your Vocal Range is :")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .bold(true)
                            .frame(maxWidth : .infinity, alignment : .center)
                            .padding(.bottom , 10)
                            .padding(.top, 20)
                        
                        GroupBox{
                            Text(vocalRange.getVocalType(lowFreq: freq[0], highFreq: freq[1]).uppercased())
                                .foregroundStyle(Color("YellowVocal"))
                                .font(.largeTitle.bold())
                                .frame(maxWidth : .infinity, alignment : .center)
                                .padding(.bottom , 0)
                                .padding(.top, 20)
                            
                            Text("\(getChordString(frequency : freq[0])) - \(getChordString(frequency : freq[1]))")
                                .font(.title3)
                                .bold(true)
                                .frame(maxWidth : .infinity, alignment : .center)
                                .padding(.bottom, 10)
                        }
                        .background(
                            RoundedRectangle(cornerRadius : 10)
                                .fill(.white)
                                .shadow(color : .gray.opacity(0.3), radius: 5,x : -2, y : 3)
                        )
                        .backgroundStyle(Color.clear)
                        .frame(maxWidth : .infinity, alignment : .center)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 20)
                        
                        
                        ScrollView(.horizontal, showsIndicators : false){
                            HStack(spacing : 20){
                                GroupBox{
                                    VStack{
                                       
                                        Text("Vocal WarmUp")
                                            .multilineTextAlignment(.center)
                                            .font(.title.bold())
                                            .frame(maxWidth : .infinity, alignment : .center)
                                            .padding(.vertical, 20)
                                            .padding(.horizontal, 10)
                                        
                                        Image("VocalWarmUp")
                                            .resizable()
                                            .frame(width : 180, height : 180)
                                        
                                        Text("Get your voice ready with quick and easy warm-ups to sing better, stronger, and safer.")
                                            .multilineTextAlignment(.center)
                                            .font(.caption)
                                            .padding(.horizontal, 20)
                                            .frame(maxWidth : .infinity, maxHeight : .infinity)
                                        
                                        
                                        Button(
                                            action : {
                                                path.append("warmup")
                                            }
                                        ){
                                            Text("Start")
                                                .foregroundStyle(.white)
                                                .frame(maxWidth : .infinity)
                                        }
                                        .padding(.vertical, 10)
                                        .background(Color("YellowWarmupCard"))
                                        .cornerRadius(10)
                                        .padding()
                                    }
                                    
                                    
                                }
                                .backgroundStyle(Color.clear)
                                .background(
                                    RoundedRectangle(cornerRadius : 10)
                                        .fill(Color("YellowWarmupCard").opacity(0.1))
                                        .stroke(Color("YellowWarmupCard"), lineWidth : 1)
                                )
                                .frame(width : 300)
                                .padding(.leading, 50)
                                
                                GroupBox{
                                    VStack{
                                       
                                        Text("Vocal Exercise")
                                            .multilineTextAlignment(.center)
                                            .font(.title.bold())
                                            .frame(maxWidth : .infinity, alignment : .center)
                                            .padding(.vertical, 20)
                                            .padding(.horizontal, 10)
                                        
                                        Image("VocalExercise")
                                            .resizable()
                                            .frame(width : 180, height : 180)
                                        
                                        Text("Get your voice ready with quick and easy warm-ups to sing better, stronger, and safer.")
                                            .multilineTextAlignment(.center)
                                            .font(.caption)
                                            .padding(.horizontal, 20)
                                            .frame(maxWidth : .infinity, maxHeight : .infinity)
                                        
                                        
                                        Button(
                                            action : {
                                                path.append("exercise")
                                            }
                                        ){
                                            Text("Start")
                                                .foregroundStyle(.white)
                                                .frame(maxWidth : .infinity)
                                        }
                                        .padding(.vertical, 10)
                                        .background(Color("RedExerciseCard"))
                                        .cornerRadius(10)
                                        .padding()
                                    }
                                    
                                    
                                }
                                .backgroundStyle(Color.clear)
                                .background(
                                    RoundedRectangle(cornerRadius : 10)
                                        .fill(Color("RedExerciseCard").opacity(0.1))
                                        .stroke(Color("RedExerciseCard"), lineWidth : 1)
                                )
                                .frame(width : 300)
                                

                                GroupBox{
                                    VStack{
                                       
                                        Text("Re-Test Vocal Range")
                                            .multilineTextAlignment(.center)
                                            .font(.title.bold())
                                            .frame(maxWidth : .infinity, alignment : .center)
                                            .padding(.vertical, 20)
                                            .padding(.horizontal, 10)
                                        
                                        Image("VocalTest")
                                            .resizable()
                                            .frame(width : 180, height : 180)
                                        
                                        Text("Get your voice ready with quick and easy warm-ups to sing better, stronger, and safer.")
                                            .multilineTextAlignment(.center)
                                            .font(.caption)
                                            .padding(.horizontal, 20)
                                            .frame(maxWidth : .infinity, maxHeight : .infinity)
                                        
                                        
                                        Button(
                                            action : {
                                                if let user = userProfile.first{
                                                    print(user.gender)
                                                    if user.gender == "Male" || user.gender == "Female"{
                                                        path.append("vtinstruction")
                                                        return;
                                                    }
                                                    path.append("vocaltest")
                                                }
                                            }
                                        ){
                                            Text("Start")
                                                .foregroundStyle(.white)
                                                .frame(maxWidth : .infinity)
                                        }
                                        .padding(.vertical, 10)
                                        .background(Color("GreenVocalTestCard"))
                                        .cornerRadius(10)
                                        .padding()
                                    }
                                
                                }
                                .backgroundStyle(Color.clear)
                                .background(
                                    RoundedRectangle(cornerRadius : 10)
                                        .fill(Color("GreenVocalTestCard").opacity(0.1))
                                        .stroke(Color("GreenVocalTestCard"), lineWidth : 1)
                                )
                                .frame(width : 300)
                                .padding(.trailing, 50)
                            }
                            
                            
                            
                        }
                        .padding(.top, 30)
                        
                       
                        
                    }
                }
                .onAppear(){
                    if let prof = userProfile.first{
                        freq = [Int(prof.lowestFrequency), Int(prof.highestFrequency)]
                    }else{
                        let newProf = UserProfile(
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
