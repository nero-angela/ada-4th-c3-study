//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.


import SwiftUI
import AudioKit
import AVFoundation

struct Complex {
  var real: Double
  var imag: Double
  
  init(_ real: Double, _ imag: Double) {
    self.real = real
    self.imag = imag
  }
  
  static func + (lhs: Complex, rhs: Complex) -> Complex {
    Complex(lhs.real + rhs.real, lhs.imag + rhs.imag)
  }
  
  static func - (lhs: Complex, rhs: Complex) -> Complex {
    Complex(lhs.real - rhs.real, lhs.imag - rhs.imag)
  }
  
  static func * (lhs: Complex, rhs: Complex) -> Complex {
    Complex(lhs.real * rhs.real - lhs.imag * rhs.imag,
            lhs.real * rhs.imag + lhs.imag * rhs.real)
  }
}

func fft(_ input: [Complex]) -> [Complex] {
  let n = input.count
  if n == 1 {
    return input
  }
  if n & (n - 1) != 0 {
    fatalError("Input size must be a power of 2")
  }
  let even = fft((0..<n/2).map { input[2*$0] })
  let odd = fft((0..<n/2).map { input[2*$0 + 1] })
  
  var output = Array(repeating: Complex(0,0), count: n)
  for k in 0..<n/2 {
    let twiddle = Complex(cos(-2 * Double.pi * Double(k) / Double(n)),
                          sin(-2 * Double.pi * Double(k) / Double(n)))
    output[k] = even[k] + twiddle * odd[k]
    output[k + n/2] = even[k] - twiddle * odd[k]
  }
  return output
}

class AudioManager: ObservableObject {
  private var audioEngine = AVAudioEngine()
  private var inputNode: AVAudioInputNode?
  let windowSize = 8192
  
  let noteFrequencies: [(name: String, freq: Double)] = [
    ("E2", 82.41), ("F2", 87.31), ("F#2/Gb2", 92.50), ("G2", 98.00), ("G#2/Ab2", 103.83),
    ("A2", 110.00), ("A#2/Bb2", 116.54), ("B2", 123.47), ("C3", 130.81), ("C#3/Db3", 138.59),
    ("D3", 146.83), ("D#3/Eb3", 155.56), ("E3", 164.81), ("F3", 174.61), ("F#3/Gb3", 185.00),
    ("G3", 196.00), ("G#3/Ab3", 207.65), ("A3", 220.00), ("A#3/Bb3", 233.08), ("B3", 246.94),
    ("C4", 261.63), ("C#4/Db4", 277.18), ("D4", 293.66), ("D#4/Eb4", 311.13), ("E4", 329.63),
    ("F4", 349.23), ("F#4/Gb4", 369.99), ("G4", 392.00), ("G#4/Ab4", 415.30), ("A4", 440.00),
    ("A#4/Bb4", 466.16), ("B4", 493.88), ("C5", 523.25), ("C#5/Db5", 554.37), ("D5", 587.33),
    ("D#5/Eb5", 622.25), ("E5", 659.26), ("F5", 698.46), ("F#5/Gb5", 739.99), ("G5", 783.99),
    ("G#5/Ab5", 830.61), ("A5", 880.00), ("A#5/Bb5", 932.33), ("B5", 987.77), ("C6", 1046.50)
  ]
  
  func getClosestNoteName(for frequency: Double) -> String {
    var minDiff = Double.infinity
    var closestNote = ""
    for note in noteFrequencies {
      let diff = abs(note.freq - frequency)
      if diff < minDiff {
        minDiff = diff
        closestNote = note.name
      }
    }
    return closestNote
  }
  
  func startRecording() {
    inputNode = audioEngine.inputNode
    let inputFormat = inputNode!.outputFormat(forBus: 0)
    print("마이크 샘플링 주파수: \(inputFormat.sampleRate) Hz")
    
    inputNode?.installTap(onBus: 0, bufferSize: AVAudioFrameCount(windowSize), format: inputFormat) { buffer, time in
      // Audio data in buffer
      guard let channelData = buffer.floatChannelData?[0] else { return }
      let frameLength = Int(buffer.frameLength)
      
      // RMS 계산
      var sumSquares: Double = 0
      for i in 0..<frameLength {
        let sample = Double(channelData[i])
        sumSquares += sample * sample
      }
      let rms = sqrt(sumSquares / Double(frameLength))
      
      // 임계값 체크
      let threshold = 0.003
      if rms < threshold {
        // 신호가 약해서 분석 안함
        return
      }
      
      var samples = [Complex]()
      for i in 0..<self.windowSize {
        let window = 0.5 * (1 - cos(2 * Double.pi * Double(i) / Double(self.windowSize - 1)))
        samples.append(Complex(Double(channelData[i]) * window, 0))
      }
      
      // Ensure samples count is a power of two
      let N = self.windowSize
      if samples.count >= N {
        let fftInput = Array(samples[0..<N])
        let fftResult = fft(fftInput)
        let magnitudes = fftResult.map { sqrt($0.real * $0.real + $0.imag * $0.imag) }
        
        let halfN = N / 2
        let magnitudesHalf = magnitudes[0..<halfN]
        if let maxMagnitude = magnitudesHalf.max(),
           let maxIndex = magnitudesHalf.firstIndex(of: maxMagnitude) {
          let frequency = Double(maxIndex) * inputFormat.sampleRate / Double(N)
          let noteName = self.getClosestNoteName(for: frequency)
          print("Max Magnitude: \(maxMagnitude), Max Index: \(maxIndex), Frequency: \(frequency) Hz, Note: \(noteName)")
        }
      }
    }
    
    try? audioEngine.start()
  }
  
  func stopRecording() {
    inputNode?.removeTap(onBus: 0)
    audioEngine.stop()
  }
}


final class FrequencyAnalysisViewModel: BaseViewModel<FrequencyAnalysisViewState> {
  let audioManager = AudioManager()
  
  init() {
    super.init(state: .init(
      amplitudes: Array(repeating: 0.0, count: 512),
      dominantNote: ""
    ))
    audioManager.startRecording()
  }
  
  override func dispose() {
    audioManager.stopRecording()
  }
}
