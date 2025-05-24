//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SplashView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { SplashViewModel() }
    ) { viewModel, _ in
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
        .tint(.accentColor)
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            viewModel.onLoaded()
            router.setRoot(.home)
          }
        }
    }
  }
}

#Preview {
  BasePreview {
    SplashView()
  }
}
