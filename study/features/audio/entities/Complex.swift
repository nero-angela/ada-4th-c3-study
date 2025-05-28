//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

struct Complex {
  // 실수부 (cos 성분)
  var real: Double

  // 허수부 (sin 성부)
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
