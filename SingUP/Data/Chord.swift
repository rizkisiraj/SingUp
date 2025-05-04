//
//  Chord.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//


var chord: [String] = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
var lim : [Int] = [33, 65, 131, 262, 523, 1047, 2093, 4186];


//Ini buat nentuin chord by scale , nanti ada ku buat tabel nya
func chordyfy (scale : Float) -> Int{
    print("Scale : \(scale)")
    if scale >= 0.95{
        return 11;
    }else if scale >= 0.8{
        return 10;
    }else if scale >= 0.7{
        return 9;
    }else if scale >= 0.6{
        return 8;
    }else if scale >= 0.5{
        return 7;
    }else if scale >= 0.4{
        return 6;
    }else if scale >= 0.3{
        return 5;
    }else if scale >= 0.25{
        return 4;
    }else if scale >= 0.2{
        return 3;
    }else if scale >= 0.1{
        return 2;
    }else if scale >= 0.05{
        return 1;
    }else {
        return 0;
    }
}


//Terus ntar frequensinya kita buat agar bisa tau chord
func getChordByFrequency(freq : Int) -> [Int] {
    var octave : Int = 1
    if(freq >= 2090){
        octave = 7;
    }else if(freq >= 1045){
        octave = 6;
    }else if(freq >= 520){
        octave = 5;
    }else if(freq >= 260){
        octave = 4;
    }else if(freq >= 130){
        octave = 3;
    }else if(freq >= 65){
        octave = 2;
    }else{
        octave = 1;
    }
    
    var scale : Float = Float( abs( Float(freq) - Float(lim[octave-1]) )) / Float( abs(lim[octave-1] - lim[octave])  );
    
    return [ chordyfy(scale: scale) , octave ];
}
