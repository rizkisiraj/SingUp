//
//  Untitled.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 06/05/25.
//

import SwiftData
import SwiftUI

@Model
class UserProfile {
    var gender:String
    var lowestFrequency:Float
    var highestFrequency:Float
    var hasScale:Bool
    
    init(gender: String, lowestFrequency: Float, highestFrequency: Float, hasScale:Bool ) {
        self.hasScale = hasScale
        self.gender = gender
        self.lowestFrequency = lowestFrequency
        self.highestFrequency = highestFrequency
    }
}
