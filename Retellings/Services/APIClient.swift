//
//  APIClient.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct APIClient {
    var fetchSummary: @Sendable () async throws -> BookSummary
    var fetchAudiosList: @Sendable () async throws -> [String]

    struct Failure: Error, Equatable {}
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

extension APIClient: TestDependencyKey {
    static let testValue = Self(fetchSummary: { .test }, fetchAudiosList: { [] })
}

extension APIClient: DependencyKey {
    static let liveValue = Self(
        fetchSummary: {
            try? await Task.sleep(for: .seconds(2))
            if Bool.random(),
                let url = Bundle.main.url(forResource: "bookSummary", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let summary = try? JSONDecoder().decode(BookSummary.self, from: data) {
                return summary
            } else {
                throw Failure()
            }
        },
        fetchAudiosList: {
            try? await Task.sleep(for: .seconds(2))

            if Bool.random() {
                return ["1", "2", "3", "4"]
            } else {
                throw Failure()
            }
        }
    )
}
