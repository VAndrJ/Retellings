//
//  ListeningReducer.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import ComposableArchitecture
import TCAComposer

@ComposeReducer(
    children: [
        .reducer("player", of: PlayerReducer.self)
    ]
)
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
        var keyPoint = 0

        var currentKeyPoint: Int { min(total, keyPoint + 1) }
        var total: Int {
            switch status {
            case let .data(points): points.points.count
            default: 0
            }
        }
        var currentTitle: String {
            switch status {
            case let .data(points): points.points.element(at: keyPoint)?.title ?? "No title"
            default: ""
            }
        }
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
            case updateRate(Float)
            case seek(toTime: Double)
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
        case let .seek(toTime):
            return .run { send in
                await send(.player(.view(.seek(toTime: toTime))))
            }
        case let .updateRate(speed):
            return .run { send in
                await send(.player(.view(.updateRate(speed))))
            }
        case .previous:
            if state.isPreviousAvailable,
                let url = state.status.data?.points.element(at: state.keyPoint - 1)?.url {
                state.keyPoint -= 1
                return .run { send in
                    await send(.player(.effect(.load(url))))
                }
            } else {
                return .none
            }
        case .next:
            if state.isNextAvailable,
                let url = state.status.data?.points.element(at: state.keyPoint + 1)?.url {
                state.keyPoint += 1
                return .run { send in
                    await send(.player(.effect(.load(url))))
                }
            } else {
                return .none
            }
        case .seekBackward:
            return .run { send in
                await send(.player(.view(.seekBackward)))
            }
        case .seekForward:
            return .run { send in
                await send(.player(.view(.seekForward)))
            }
        case .playPause:
            return .run { send in
                await send(.player(.view(.playPause)))
            }
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
            state.keyPoint = 0
            state.status = .data(data)

            if let url = state.status.data?.points.element(at: state.keyPoint)?.url {
                return .run { send in
                    await send(.player(.effect(.load(url))))
                }
            } else {
                return .none
            }
        case .fetchDataResult(.failure):
            state.status = .loadingFailed(.audioListLoadingFailed)

            return .none
        }
    }
}
