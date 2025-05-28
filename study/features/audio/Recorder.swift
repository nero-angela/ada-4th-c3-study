//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

class Recorder: ObservableObject {
  private var audioEngine = AVAudioEngine()
  private var inputNode: AVAudioInputNode?
  var inputFormat: AVAudioFormat?

  func start(_ windowSize: Int, _ handler: @escaping AVAudioNodeTapBlock) {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
      try session.setPreferredSampleRate(48000)
      try session.setActive(true)
    } catch {
      print("AVAudioSession 설정 중 오류 발생: \(error)")
    }

    inputNode = audioEngine.inputNode
    inputFormat = inputNode!.outputFormat(forBus: 0)
    inputNode?.installTap(onBus: 0, bufferSize: AVAudioFrameCount(windowSize), format: inputFormat, block: handler)
    try? audioEngine.start()
  }

  func stop() {
    inputNode?.removeTap(onBus: 0)
    audioEngine.stop()
  }
}
