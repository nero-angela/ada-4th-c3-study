//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { HomeViewModel() }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "ADA 4th C3 Team1", isPopButton: false)

        List {
          // MARK: GA1 - Architecture
          Section(header: Text("GA1 - Architecture")) {
            Tile(title: "Diary", subtitle: "Nell") {
              router.push(.diary)
            }
            Tile(title: "Bucket", subtitle: "Isla") {
              router.push(.bucket)
            }
            Tile(title: "Todo", subtitle: "Jeje") {
              router.push(.todo)
            }
          }

          // MARK: GA2 - Prototype
          Section(header: Text("GA2 - Prototype")) {
            Tile(title: "Sample", subtitle: "Nickname") {
              router.push(.prototypeSample)
            }
            Tile(title: "Frequency Analysis", subtitle: "Nell") {
              router.push(.frequencyAnalysis)
            }
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    HomeView()
  }
}
