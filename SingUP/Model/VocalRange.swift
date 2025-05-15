//
//  VocalRange.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 06/05/25.
//
import SwiftUI

var vocalRange = [
    "bass" : "Bass is the lowest voice in the human range. Your voice is deep and resonant sound",
    "baritone" : "Baritone is a voice that lies between the bass and tenor. Your voice is warm and rich of tone",
    "tenor" : "Tenor is a voice that lies between the baritone and soprano. Your voice is bright and clear tone",
    "alto" : "Alto is a voice that lies above the tenor. Your voice is warm and rich of tone",
    "mezzo" : "Mezzo is a voice that lies between the alto and soprano. Your voice is warm and rich tone",
    "soprano" : "Soprano is the highest voice in the human range. Your voice is clear and bright"
]

class VocalRange{
    public var range : [String] = ["Bass", "Baritone", "Tenor", "Alto", "Mezzo", "Soprano"]
    
    
    func getVocalType(lowFreq : Int, highFreq : Int)->String{
        if lowFreq >= 98 {
            return "Tenor"
        }else if lowFreq >= 82 {
            return "Baritone"
        }else  {
            return "Bass"
        }
    }
    
    func getVocalTypeIndex(lowFreq : Int, highFreq : Int)->Int{
        if lowFreq >= 98 {
            return 2
        }else if lowFreq >= 82 {
            return 1
        }else  {
            return 0
        }
    }
}

#Preview{
    ContentView()
}
