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

        var status: Status = .idle
    }

    enum Actions: Equatable {
        enum View: Equatable {
            case onAppear
        }

        enum Effect: Equatable {
            case fetchData
        }
    }

    @ComposeBodyActionCase
    func view(state: inout State, action: Actions.View) -> EffectOf<Self> {
        switch action {
        case .onAppear:
            return .none
        }
    }

    @ComposeBodyActionCase
    func effect(state: inout State, action: Actions.Effect) -> EffectOf<Self> {
        switch action {
        case .fetchData:
            return .none
        }
    }
}
