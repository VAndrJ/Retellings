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
        enum Status: Equatable {
            case idle
            case loading
            case data(String)
            case loadingFailed(MyAwesomeError)
        }

        var currentSummary: String?
        var status: Status = .idle
        var isPlaying = false
        var keyPoint = 0
        var total = 2

        var isPreviousAvailable: Bool { keyPoint > 0 }
        var isNextAvailable: Bool { keyPoint < total - 1 }
    }

    enum Actions: Equatable {
        enum View: Equatable {
            case onAppear
            case previous
            case next
            case seekBackward
            case seekForward
            case playPause
        }

        enum Effect: Equatable {
            case updateSummary(String)
            case fetchData(String)
        }
    }

    @Dependency(\.apiClient.fetchAudiosList)
    private var fetchAudiosList

    @ComposeBodyActionCase
    func view(state: inout State, action: Actions.View) -> EffectOf<Self> {
        switch action {
        case .onAppear:
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
            assertionFailure("implement")
            return .none
        }
    }
}
