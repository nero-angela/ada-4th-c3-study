//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct FrequencyAnalysisViewState {
  let amplitudes: [Float]
  let note: String
  let freq: Double

  func copy(amplitudes: [Float]? = nil, note: String? = nil, freq: Double? = nil) -> FrequencyAnalysisViewState {
    return FrequencyAnalysisViewState(
      amplitudes: amplitudes ?? self.amplitudes,
      note: note ?? self.note,
      freq: freq ?? self.freq
    )
  }
}
