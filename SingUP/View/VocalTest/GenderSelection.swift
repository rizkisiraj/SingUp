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
    
    var body : some View{
        VStack(){
            Text("Select Gender")
                .font(.title)
                .bold(true)
                .padding(.bottom, 50)
            
            GroupBox{
                HStack{
                    Image(systemName: "person.fill")
                        .font(.title)
                        .foregroundStyle(.white)

                    Text("MALE")
                        .font(.title)
                        .foregroundStyle(.white)

                }
                .padding(.vertical, 20)
                .frame(maxWidth : .infinity)

            }
            .backgroundStyle(.black)
            .padding(.horizontal, 50)
            .onTapGesture {
                if let user = userProfile.first{
                    user.gender = "Male"
                    do{
                        try context.save()
                        print("Berhasil mengsave gender !")
                    }catch{
                        print("Gagal menyimpan gender ! \(error)")
                    }
                }
                path.append("vtinstruction")
            }
            .padding(.bottom, 50)
            
            GroupBox{
                HStack{
                    Image(systemName: "person.fill")
                        .font(.title)
                        .foregroundStyle(.white)


                    Text("FEMALE")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 20)
                .frame(maxWidth : .infinity)

            }
            .backgroundStyle(.black)
            .padding(.horizontal, 50)
            .onTapGesture {
                if let user = userProfile.first{
                    user.gender = "Female"
                    do{
                        try context.save()
                        print("Berhasil mengsave gender !")

                    }catch{
                        print("Gagal menyimpan gender ! \(error)")
                    }
                }
                path.append("vtinstruction")
            }
            
        }
       
        
        
    }
}



#Preview{
    @Previewable @State var path = NavigationPath()

    GenderSelection(path : $path)
    //ContentView()
}
