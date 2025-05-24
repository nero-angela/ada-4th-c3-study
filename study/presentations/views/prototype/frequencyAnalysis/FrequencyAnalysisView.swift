//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct FrequencyAnalysisView: View {
  var body: some View {
    BaseView(
      create: { FrequencyAnalysisViewModel() }
    ) { viewModel, state in
      VStack {
        Toolbar(title: "Frequency Analysis")
        
      }
    }
  }
}

#Preview {
  BasePreview {
    FrequencyAnalysisView()
  }
}
