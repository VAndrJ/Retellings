//
//  AppReducer.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import ComposableArchitecture
import TCAComposer

@ComposeReducer(
    .bindable,
    children: [
        .reducer("listeningSummary", of: ListeningReducer.self),
        .reducer("readingSummary", of: ReadingReducer.self),
    ]
)
@Composer
struct AppReducer {
    struct State: Equatable {
        enum Status: Equatable {
            case idle
            case loading
            case data(BookSummary)
            case loadingFailed(MyAwesomeError)
        }

        var tab: RetellingTab = .listening
        var status: Status = .idle
    }

    enum Actions: Equatable {
        enum View: Equatable {
            case select(tab: RetellingTab)
            case onAppear
            case tryAgain
        }

        enum Effect: Equatable {
            case fetchData
            case fetchDataResult(TaskResult<BookSummary>)
        }
    }

    enum CancelToken {
        case loading
    }

    @Dependency(\.apiClient.fetchSummary)
    private var fetchSummary

    @ComposeBodyActionCase
    func view(state: inout State, action: Actions.View) -> EffectOf<Self> {
        switch action {
        case let .select(tab):
            state.tab = tab

            return .none
        case .tryAgain:
            switch state.status {
            case .loadingFailed:
                return .run { send in
                    await send(.effect(.fetchData))
                }
            case .loading, .data, .idle:
                return .none
            }
        case .onAppear:
            switch state.status {
            case .idle, .loadingFailed:
                return .run { send in
                    await send(.effect(.fetchData))
                }
            case .loading, .data:
                return .none
            }
        }
    }

    @ComposeBodyActionCase
    func effect(state: inout State, action: Actions.Effect) -> EffectOf<Self> {
        switch action {
        case .fetchData:
            state.status = .loading

            return .run { send in
                return await send(.effect(.fetchDataResult(TaskResult { try await fetchSummary() })))
            }
            .cancellable(id: CancelToken.loading, cancelInFlight: true)
        case let .fetchDataResult(.success(data)):
            state.status = .data(data)
            state.readingSummary.status = .data(data.about)

            return .run { send in
                await send(.listeningSummary(.effect(.updateSummary(data.id))))
            }
        case .fetchDataResult(.failure):
            // TODO: - Error mapping, or direct usage.
            state.status = .loadingFailed(.summaryLoadingFailed)

            return .none
        }
    }
}
