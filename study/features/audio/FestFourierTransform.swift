//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import AVFoundation

// DFT(Discrete Fourier Transform)는 O(N^2) 걸림
// FFT(Fest Fourier Transform)는 분할 정복으로 계산량을 O(NLogN)으로 줄임
// 길이 n의 신호를 짝수 인덱스 샘플과 홀수 인덱스 샘플로 나눔
class FestFourierTransform {
  func run(_ input: [Complex]) -> [Complex] {
    let n = input.count
    if n == 1 {
      return input
    }
    if n & (n - 1) != 0 {
      fatalError("Input size must be a power of 2")
    }
    let even = run((0 ..< n / 2).map { input[2 * $0] })
    let odd = run((0 ..< n / 2).map { input[2 * $0 + 1] })

    var output = Array(repeating: Complex(0, 0), count: n)
    for k in 0 ..< n / 2 {
      let twiddle = Complex(cos(-2 * Double.pi * Double(k) / Double(n)),
                            sin(-2 * Double.pi * Double(k) / Double(n)))
      output[k] = even[k] + twiddle * odd[k]
      output[k + n / 2] = even[k] - twiddle * odd[k]
    }
    return output
  }
}
