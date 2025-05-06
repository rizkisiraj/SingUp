//
//  VocalRange.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 06/05/25.
//

class VocalRange{
    
    func getVocalType(lowFreq : Int, highFreq : Int)->String{
        if lowFreq >= 98 {
            return "Tenor"
        }else if lowFreq >= 82 {
            return "Baritone"
        }else  {
            return "Bass"
        }
    }
}
