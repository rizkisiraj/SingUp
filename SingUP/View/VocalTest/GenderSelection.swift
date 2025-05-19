//
//  yes.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//

import SwiftUI
import SwiftData

struct GenderSelection : View{
    @Binding var path : NavigationPath
    @Environment(\.modelContext) var context
    @Query var userProfile : [UserProfile]
    @State var gambarImage = "Male"
    enum Gender: String, CaseIterable, Identifiable {
        case male, female
        var id: Self { self }
    }


    @State private var selected: Gender = .male
    
    var body : some View{
        VStack(){
            Text("Choose Gender")
                .font(.title)
                .bold(true)
                .padding(.bottom, 10)
            
            Text("Selecting gender make your vocal type more accurate, because male and female have different vocal type")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding(.horizontal, 50)
                .padding(.bottom, 20)
            
            
            Picker("Flavor", selection: $selected) {
                    Text("Male").tag(Gender.male)
                    Text("Female").tag(Gender.female)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 50)
            .padding(.bottom, 20)

            Image(selected != Gender.male ? "Female" :"Male")
                .resizable()
                .frame(width: 250, height: 250)
                .offset(x : 25)
                
            Button(
                action : {
                    if let user = userProfile.first{
                       user.gender = selected == .male ? "Male" :"Female"
                       do{
                           try context.save()
                           print("Berhasil mengsave gender \(user.gender) !")
   
                       }catch{
                           print("Gagal menyimpan gender ! \(error)")
                       }
                   }
                   path.append("vtinstruction")
                }
            ) {
                Text("Continue")
                    .foregroundStyle(.white)
                    .frame(maxWidth : .infinity)
            }
            .padding(.vertical, 15)
            .background(.blue)
//            selected != Gender.male ? Color("RedFemale") : 
            .cornerRadius(10)
            .padding(50)
            
//            GroupBox{
//                HStack{
//                    Image(systemName: "person.fill")
//                        .font(.title)
//                        .foregroundStyle(.white)
//
//                    Text("MALE")
//                        .font(.title)
//                        .foregroundStyle(.white)
//
//                }
//                .padding(.vertical, 20)
//                .frame(maxWidth : .infinity)
//
//            }
//            .backgroundStyle(.black)
//            .padding(.horizontal, 50)
//            .onTapGesture {
//                if let user = userProfile.first{
//                    user.gender = "Male"
//                    do{
//                        try context.save()
//                        print("Berhasil mengsave gender !")
//                    }catch{
//                        print("Gagal menyimpan gender ! \(error)")
//                    }
//                }
//                path.append("vtinstruction")
//            }
//            .padding(.bottom, 50)
//            
//            GroupBox{
//                HStack{
//                    Image(systemName: "person.fill")
//                        .font(.title)
//                        .foregroundStyle(.white)
//
//
//                    Text("FEMALE")
//                        .font(.title)
//                        .foregroundStyle(.white)
//                }
//                .padding(.vertical, 20)
//                .frame(maxWidth : .infinity)
//
//            }
//            .backgroundStyle(.black)
//            .padding(.horizontal, 50)
//            .onTapGesture {
//                if let user = userProfile.first{
//                    user.gender = "Female"
//                    do{
//                        try context.save()
//                        print("Berhasil mengsave gender !")
//
//                    }catch{
//                        print("Gagal menyimpan gender ! \(error)")
//                    }
//                }
//                path.append("vtinstruction")
//            }
            
        }
       
        
        
    }
}



#Preview{
    @Previewable @State var path = NavigationPath()

    GenderSelection(path : $path)
    //ContentView()
}
