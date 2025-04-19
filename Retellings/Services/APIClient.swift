//
//  APIClient.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import ComposableArchitecture

@DependencyClient
struct APIClient {
    var fetchSummary: @Sendable () async throws -> String
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
    static let testValue = Self(fetchSummary: { "Hello, world!" }, fetchAudiosList: { [] })
}

extension APIClient: DependencyKey {
    static let liveValue = Self(
        fetchSummary: {
            try? await Task.sleep(for: .seconds(2))

            if Bool.random() {
                return "Hello, world!"
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
