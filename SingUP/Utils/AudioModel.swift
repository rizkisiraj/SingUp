//
//  AudioModel.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 04/05/25.
//

import SwiftUI
import AVFoundation
import Accelerate

class FrequencyDetector: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode!
    private let fftSize: Int = 2048
    var lastFrequency: Float = 0.0
    let alpha: Float = 0.25
    private var fftSetup: FFTSetup?
    public var useFilter = false
    
    @Published var frequency: Float = 0.0

    init() {
        do {
            try setupAudio()
        } catch {
            
        }
    }
    
    enum AudioSetupError: Error {
        case fftSetupFailed
    }

    func setupAudio() throws {
        #if targetEnvironment(simulator)
        return
        #endif

        inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)

        guard let fft = vDSP_create_fftsetup(vDSP_Length(log2(Float(fftSize))), FFTRadix(kFFTRadix2)) else {
            throw AudioSetupError.fftSetupFailed
        }
        fftSetup = fft

        inputNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(fftSize), format: format) { buffer, _ in
            self.analyzeBuffer(buffer: buffer)
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .measurement)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioEngine.start()
        } catch {
            print("Audio session setup failed: \(error)")
            throw error
        }
    }


    func analyzeBuffer(buffer: AVAudioPCMBuffer) {
        let channelData = buffer.floatChannelData?[0]
        _ = Int(buffer.frameLength)
        let channelArray = Array(UnsafeBufferPointer(start: channelData, count: fftSize))

        let window = vDSP.window(ofType: Float.self,
                                 usingSequence: .hanningDenormalized,
                                 count: fftSize,
                                 isHalfWindow: false)
        var windowedSignal = [Float](repeating: 0.0, count: fftSize)
        vDSP.multiply(channelArray, window, result: &windowedSignal)

        var real = [Float](repeating: 0.0, count: fftSize / 2)
        var imag = [Float](repeating: 0.0, count: fftSize / 2)

        real.withUnsafeMutableBufferPointer { realPtr in
            imag.withUnsafeMutableBufferPointer { imagPtr in
                var splitComplex = DSPSplitComplex(realp: realPtr.baseAddress!, imagp: imagPtr.baseAddress!)
                windowedSignal.withUnsafeBufferPointer {
                    $0.baseAddress!.withMemoryRebound(to: DSPComplex.self, capacity: fftSize) { typeConvertedData in
                        vDSP_ctoz(typeConvertedData, 2, &splitComplex, 1, vDSP_Length(fftSize / 2))
                    }
                }

                if let fft = fftSetup {
                    vDSP_fft_zrip(fft, &splitComplex, 1, vDSP_Length(log2(Float(fftSize))), FFTDirection(FFT_FORWARD))
                }

                var magnitudes = [Float](repeating: 0.0, count: fftSize / 2)
                vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(fftSize / 2))

                if let maxMagnitude = magnitudes.max(),
                   let maxIndex = magnitudes.firstIndex(of: maxMagnitude) {

                    if maxMagnitude > 200.0 {
                        let sampleRate = Float(buffer.format.sampleRate)
                        let freq = sampleRate * Float(maxIndex) / Float(fftSize)
                        if useFilter{
                            DispatchQueue.main.async {
                                // Apply low-pass smoothing
                                let smoothed = self.lastFrequency + self.alpha * (freq - self.lastFrequency)
                                self.lastFrequency = smoothed
                                self.frequency = smoothed
                            }
                        }else{
                            DispatchQueue.main.async {
                                // Apply low-pass smoothing
                                self.frequency = freq
                            }
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            self.frequency = 0.0
                        }
                    }
                }
            }
        }
    }


    deinit {
        inputNode.removeTap(onBus: 0)
        vDSP_destroy_fftsetup(fftSetup)
        audioEngine.stop()
    }
}


#Preview {
    ContentView()
}

