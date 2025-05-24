//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct FrequencyAnalysisViewState {
  let amplitudes: [Float]
  let dominantNote: String
  
  func copy(amplitudes: [Float]? = nil, dominantNote: String? = nil) -> FrequencyAnalysisViewState {
    return FrequencyAnalysisViewState(
      amplitudes: amplitudes ?? self.amplitudes,
      dominantNote: dominantNote ?? self.dominantNote
    )
  }
}
