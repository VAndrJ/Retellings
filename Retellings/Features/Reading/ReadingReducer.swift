//
//  ReadingReducer.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import TCAComposer
import ComposableArchitecture

@Composer
struct ReadingReducer {
    struct State: Equatable {
        enum Status: Equatable {
            case idle
            case data(String)
        }

        var status: Status = .idle
    }

    enum Actions: Equatable {
        enum View: Equatable {
            case onAppear
        }
    }

    @ComposeBodyActionCase
    func view(state: inout State, action: Actions.View) -> EffectOf<Self> {
        switch action {
        case .onAppear:
            return .none
        }
    }
}
