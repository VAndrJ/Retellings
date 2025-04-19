//
//  KeyPoint.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import Foundation

struct KeyPoint: Decodable, Equatable {
    let title: String
    let audio: String
}

extension KeyPoint {
    static var test: KeyPoint {
        .init(
            title: "title",
            audio: "audio"
        )
    }
}
