//
//  Double+Support.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

extension Double {
    var normalized: Double {
        if isInfinite || isNaN {
            return 0
        } else {
            return max(0, self)
        }
    }
}

extension FloatingPoint {

    func isRoughlyEqual(to other: Self, precision: Self) -> Bool {
        abs(self - other) < precision
    }
}
