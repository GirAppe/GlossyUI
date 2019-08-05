//
//  Utils.swift
//  GlossyUI
//
//  Created by Andrzej Michnia on 31/05/2019.
//

import Foundation

typealias VoidCompletion = () -> Void

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension FloatingPoint {
    func transition(_ a: Self, _ b: Self) -> Self {
        let aWeight = 1 - self
        let bWeight = self
        return a * aWeight + b * bWeight
    }
}

extension Double {
    static var pi½: Double { return Double.pi / 2 }
}

func dlog(_ message: @autoclosure () -> String) {
    #if DEBUG
    print(message())
    #endif
}
