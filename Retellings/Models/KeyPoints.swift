//
//  KeyPoints.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import Foundation

struct KeyPoints: Decodable, Equatable {
    let url: URL
    let points: [KeyPoint]
}

extension KeyPoints {
    static var test: KeyPoints {
        .init(
            url: URL(
                string: "https://static.headway-academy.com/courses/art/cover.png"
            )!,
            points: [.test]
        )
    }
}
