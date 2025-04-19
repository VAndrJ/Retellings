//
//  AppReducer.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import ComposableArchitecture
import TCAComposer

@ComposeReducer(.bindable)
@Composer
struct AppReducer {
    struct State: Equatable {
        var tab: RetellingTab = .listening
    }

    enum Actions {
        enum View {
            case select(tab: RetellingTab)
        }
    }

    @ComposeBodyActionCase
    func view(state: inout State, action: Actions.View) -> EffectOf<Self> {
        switch action {
        case let .select(tab):
            state.tab = tab

            return .none
        }
    }
}
