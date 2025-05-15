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
    
    public func store(date: Date, exercise: Int, accuracy: Float) {
        let newVocalTraining = VocalTraining(id: UUID(), date: date, exercise: exercise, accuracy: accuracy)
        context.insert(newVocalTraining)
        
        do {
            try context.save() // <— Tambahkan ini
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
//    public func deleteAll() {
//        let query = FetchDescriptor<VocalTraining>()
//        
//        do {
//            let allData = try context.fetch(query)
//            for item in allData {
//                context.delete(item)
//            }
//            // Jika kamu menggunakan SwiftData dengan pengaturan manual commit:
//            // try context.save()
//        } catch {
//            print("Failed to delete all data: \(error)")
//        }
//    }
    
    func fetchAll(type: Int) -> [VocalTraining] {
        let predicate = #Predicate<VocalTraining> { $0.exercise == type }
        let query = FetchDescriptor(predicate: predicate)

        do {
            self.vocalTraining = try context.fetch(query)
            print("Filtered data count: \(self.vocalTraining.count)")
        } catch {
            print("Error: \(error)")
        }

        return vocalTraining
    }

    
    
}
