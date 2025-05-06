//
//  VocalRange.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 06/05/25.
//

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
