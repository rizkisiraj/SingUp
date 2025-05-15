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
    @State var history : History?
    
    var body: some View{
        VStack{
            if page == 0 {
                VStack{
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
                                VStack{
                                   
                                }
                                .padding()
                                ForEach(homeMenus, id : \.self){ menu in
                                    GroupBox{
                                        VStack{
                                           
                                            Text(menu.title)
                                                .multilineTextAlignment(.center)
                                                .font(.title.bold())
                                                .frame(maxWidth : .infinity, alignment : .center)
                                                .padding(.vertical, 20)
                                                .padding(.horizontal, 10)
                                            
                                            Image(menu.image)
                                                .resizable()
                                                .frame(width : 180, height : 180)
                                            
                                            Text(menu.description)
                                                .multilineTextAlignment(.center)
                                                .font(.caption)
                                                .padding(.horizontal, 20)
                                                .frame(maxWidth : .infinity, maxHeight : .infinity)
                                            
                                            
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
                        .padding(.top, 30)
                        
                       
                        
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
            }else{
                HistoryPage(history : $history)
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
                            .foregroundStyle(page == 0 ? .black  : .gray)
                        Text("Home")
                            .foregroundStyle(page == 0 ? .black  : .gray)

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
                            .foregroundStyle(page == 1 ? .black  : .gray)

                        Text("History")
                            .foregroundStyle(page == 1 ? .black  : .gray)

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
