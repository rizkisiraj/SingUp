//
//  VocalTraining.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 06/05/25.
//

import SwiftData
import SwiftUI

@Model
class VocalTraining{
    var id : UUID = UUID()
    var date : Date = Date()
    var exercise : Int = 0
    var accuracy : Float = 0
    
    init(id: UUID, date: Date, exercise: Int, accuracy: Float) {
        self.id = id
        self.date = date
        self.exercise = exercise
        self.accuracy = accuracy
    }
   
}

class History{
    var context : ModelContext
    var vocalTraining : [VocalTraining] = []
    
    init(context: ModelContext) {
        self.context = context
        let query = FetchDescriptor<VocalTraining>();
        
        do{
             self.vocalTraining = try context.fetch(query)
        }catch{
            print("Error: \(error)")
        }
    }
    
    func store(date : Date, exercise : Int, accuracy : Float){
        let newVocalTraining = VocalTraining(id: UUID(), date: date, exercise: exercise, accuracy: accuracy)
        
        context.insert(newVocalTraining)
        
    }
    
    func fetchAll() -> [VocalTraining]{
        let query = FetchDescriptor<VocalTraining>();
        
        do{
             self.vocalTraining = try context.fetch(query)
        }catch{
            print("Error: \(error)")
        }
        return vocalTraining
    }
    
    
}
