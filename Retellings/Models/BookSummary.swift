//
//  BookSummary.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import Foundation

struct BookSummary: Decodable, Equatable {
    let id: String
    let title: String
    let description: String
    let about: String
    let data: String
}

extension BookSummary {
    static var test: BookSummary {
        .init(
            id: "id",
            title: "title",
            description: "description",
            about: "about",
            data: "data"
        )
    }
}
