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

    // Let's imagine this is an URL from the backend
    var url: URL? {
        let parts = audio.split(separator: ".").map(String.init)

        return Bundle.main.url(forResource: parts.first, withExtension: parts.last)
    }
}

extension KeyPoint {
    static var test: KeyPoint {
        .init(
            title: "title",
            audio: "audio"
        )
    }
}
