//
//  ListeningReducer.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import TCAComposer
import ComposableArchitecture

@Composer
struct ListeningReducer {
    struct State: Equatable {
        @CasePathable
        @dynamicMemberLookup
        enum Status: Equatable {
            case idle
            case loading
            case data(KeyPoints)
            case loadingFailed(MyAwesomeError)
        }

        var currentSummary: String?
        var status: Status = .idle
        var isPlaying = false
        var keyPoint = 0
        var speed: Float = 1.0

        var currentKeyPoint: Int { min(total, keyPoint + 1) }
        var total: Int { status.data.map(\.points)?.count ?? 0 }
        var currentTitle: String { status.data.map(\.points)?.element(at: keyPoint)?.title ?? "No title" }
        var isPreviousAvailable: Bool { keyPoint > 0 }
        var isNextAvailable: Bool { keyPoint < total - 1 }
    }

    enum Actions: Equatable {
        enum View: Equatable {
            case previous
            case next
            case seekBackward
            case seekForward
            case playPause
            case tryLoadAgain
            case updateSpeed(Float)
        }

        enum Effect: Equatable {
            case updateSummary(String)
            case fetchData(String)
            case fetchDataResult(TaskResult<KeyPoints>)
        }
    }

    private enum CancelToken {
        case loading
    }

    @Dependency(\.apiClient.fetchAudiosList)
    private var fetchAudiosList

    @ComposeBodyActionCase
    func view(state: inout State, action: Actions.View) -> EffectOf<Self> {
        switch action {
        case let .updateSpeed(speed):
            print(speed)
            state.speed = speed

            return .none
        case .previous:
            assertionFailure("implement")

            return .none
        case .next:
            assertionFailure("implement")

            return .none
        case .seekBackward:
            assertionFailure("implement")

            return .none
        case .seekForward:
            assertionFailure("implement")

            return .none
        case .playPause:
            assertionFailure("implement")

            return .none
        case .tryLoadAgain:
            if let id = state.currentSummary {
                return .run { send in
                    await send(.effect(.fetchData(id)))
                }
            } else {
                assertionFailure("check")
                return .none
            }
        }
    }

    @ComposeBodyActionCase
    func effect(state: inout State, action: Actions.Effect) -> EffectOf<Self> {
        switch action {
        case let .updateSummary(id):
            state.currentSummary = id
            state.status = .idle

            return .run { send in
                await send(.effect(.fetchData(id)))
            }
        case let .fetchData(id):
            state.status = .loading

            return .run { send in
                return await send(.effect(.fetchDataResult(TaskResult { try await fetchAudiosList(id) })))
            }
            .cancellable(id: CancelToken.loading, cancelInFlight: true)
        case let .fetchDataResult(.success(data)):
            state.status = .data(data)

            return .none
        case .fetchDataResult(.failure):
            state.status = .loadingFailed(.audioListLoadingFailed)

            return .none
        }
    }
}
