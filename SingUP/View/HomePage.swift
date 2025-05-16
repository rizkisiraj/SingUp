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
    var vocalR = VocalRange()
    @Environment(\.modelContext) var context
    @State var history : History?
    var body: some View{
        VStack{
           
            TabView(selection: $page) {
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
                            Text(vocalR.getVocalType(lowFreq: freq[0], highFreq: freq[1]).uppercased())
                                .foregroundStyle(Color("YellowVocal"))
                                .font(.largeTitle.bold())
                                .frame(maxWidth : .infinity, alignment : .center)
                                .padding(.bottom , 0)
                                .padding(.top, 20)
                           
                            
                            Text("\(getChordString(frequency : freq[0])) - \(getChordString(frequency : freq[1]))")
                                .font(.title3)
                                .bold(true)
                                .frame(maxWidth : .infinity, alignment : .center)
                            
                            
                            Text(vocalRange[vocalR.getVocalType(lowFreq: freq[0], highFreq: freq[1]).lowercased()] ?? "bass")
                                .multilineTextAlignment(.center)
                                .frame(maxWidth : .infinity)
                                .font(.caption)
                                .padding(.horizontal, 20)
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
                        .padding(.vertical, 10)
                        
                        
                        ScrollView(.horizontal, showsIndicators : false){
                            HStack(spacing : 20){
                                VStack{
                                   
                                }
                                .padding()
                                ForEach(homeMenus, id : \.self){ menu in
                                    GroupBox{
                                        VStack{
                                           
                                            Text(menu.title)
                                                .fixedSize(horizontal : false, vertical : true)
                                                .multilineTextAlignment(.center)
                                                .font(.title.bold())
                                                .padding(.vertical, 10)
                                                .padding(.horizontal, 10)
                                                .frame(maxWidth : .infinity, maxHeight : .infinity, alignment : .center)
                                            
                                            Image(menu.image)
                                                .resizable()
                                                .frame(width : 160, height : 160)
                                            
                                            Text(menu.description)
                                                .multilineTextAlignment(.center)
                                                .font(.caption)
                                                .padding(.horizontal, 20)
                                                .frame(maxWidth : .infinity, maxHeight : .infinity)
                                                .fixedSize(horizontal : false, vertical : true)
                                            
                                            Button(
                                                action : {
                                                    path.append(menu.path)
                                                }
                                            ){
                                                Text("Start")
                                                    .foregroundStyle(.white)
                                                    .frame(maxWidth : .infinity)
                                            }
                                            .padding(.vertical, 10)
                                            .background(menu.color)
                                            .cornerRadius(10)
                                            .padding()
                                        }
                                        
                                        
                                    }
                                    .backgroundStyle(Color.clear)
                                    .background(
                                        RoundedRectangle(cornerRadius : 10)
                                            .fill(menu.color.opacity(0.1))
                                            .stroke(menu.color, lineWidth : 1)
                                    )
                                    .frame(width : 300)
                                }
                                
                                VStack{
                                   
                                }
                                .padding()
                                
                            }
                            .padding(.bottom, 30)
                            
                            
                            
                        }
                        .padding(.top, 20)
                        
                       
                        
                    }
                }
                .onAppear(){
                    history = History(context : context)
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
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
                
                
                HistoryPage(history : $history)
                    .tabItem {
                        Image(systemName: "clock.fill")
                        Text("History")
                    }
                    .tag(1)
            }
            
        }
        .toolbarRole(.navigationStack)
        //Toolbar untuk navigasi
        //Pake Native ToolBar
        
        .frame(maxWidth : .infinity, maxHeight : .infinity)
        
    }
    
    
}



#Preview {
    @Previewable @State var path = NavigationPath()
    HomePage(path : $path )
}
