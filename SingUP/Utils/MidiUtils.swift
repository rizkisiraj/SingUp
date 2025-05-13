import AudioKit
import AVFoundation
import Foundation

func extractTempo(from midiFile: MIDIFile) -> Double {
    for event in midiFile.tracks.first?.events ?? [] {
        guard let midiEvent = try? MIDIEvent(data: event.data),
              midiEvent.data.count >= 6 else { continue }

        if midiEvent.data[0] == 0xFF,
           midiEvent.data[1] == 0x51,
           midiEvent.data[2] == 0x03 {

            let t1 = UInt32(midiEvent.data[3]) << 16
            let t2 = UInt32(midiEvent.data[4]) << 8
            let t3 = UInt32(midiEvent.data[5])
            let mpqn = t1 | t2 | t3

            let bpm = 60_000_000.0 / Double(mpqn)
            print("🎼 Detected BPM: \(bpm)")
            return bpm
        }
    }
    print("🎼 No tempo found. Using default 120 BPM")
    return 120.0
}


func loadMIDI(from url: URL) {
    do {
        let midiFile = try MIDIFile(url: url)

        let bpm = extractTempo(from: midiFile)
        let secondsPerBeat = 60.0 / bpm
        
        for (trackIndex, track) in midiFile.tracks.enumerated() {
            print("Track \(trackIndex):")
            
            var activeNotes: [UInt8: [UInt8: (startTime: Double, velocity: UInt8)]] = [:]
            
            for event in track.events {
                guard let midiEvent = try? MIDIEvent(data: event.data),
                      let status = midiEvent.status else {
                    continue
                }

                let statusByte = status.byte
                let messageType = statusByte & 0xF0
                let channel = statusByte & 0x0F
                let time: Double = event.positionInBeats!

                if messageType == 0x90 && midiEvent.data.count >= 3 {
                    let note = midiEvent.data[1]
                    let velocity = midiEvent.data[2]

                    if velocity > 0 {
                        // Note On
                        print("Note On - Note: \(note), Velocity: \(velocity), Channel: \(channel), Time: \(time)")
                        activeNotes[channel, default: [:]][note] = (startTime: time, velocity: velocity)
                    } else {
                        // Note Off (via Note On with velocity 0)
                        if let start = activeNotes[channel]?[note] {
                            let duration = time - start.startTime
                            print("Note Off (via Note On 0 vel) - Note: \(note), Channel: \(channel), Start: \(start.startTime), Duration: \(duration), Velocity: \(start.velocity)")
                            activeNotes[channel]?[note] = nil
                        }
                    }
                }

                if messageType == 0x80 && midiEvent.data.count >= 3 {
                    let note = midiEvent.data[1]
                    if let start = activeNotes[channel]?[note] {
                        let duration = time - start.startTime
                        print("Note Off - Note: \(note), Channel: \(channel), Start: \(start.startTime), Duration: \(duration), Velocity: \(start.velocity)")
                        activeNotes[channel]?[note] = nil
                    }
                }
            }
        }

    } catch {
        print("Failed to read MIDI: \(error)")
    }
}
