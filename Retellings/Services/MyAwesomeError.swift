//
//  MyAwesomeError.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import Foundation

enum MyAwesomeError: Error, Equatable {
    case summaryLoadingFailed
    case audioListLoadingFailed
}

extension MyAwesomeError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .summaryLoadingFailed: "Failed to load summary."
        case .audioListLoadingFailed: "Failed to load audio list."
        }
    }

    var localizedDescription: String { errorDescription ?? "Ooops, something went wrong" }
}
