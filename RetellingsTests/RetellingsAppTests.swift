//
//  RetellingsAppTests.swift
//  RetellingsTests
//
//  Created by VAndrJ on 4/18/25.
//

import Testing
import ComposableArchitecture
@testable import Retellings

@Suite("App State Tests")
struct RetellingsAppTests {

    @Test("Tab selection changes app state and keeps selection")
    func tabSelectionChangesAppState() async {
        let store = await TestStore(initialState: AppReducer.State()) {
            AppReducer()
        }

        await store.send(.view(.select(tab: .overview))) {
            $0.tab = .overview
        }
        await store.send(.view(.select(tab: .listening))) {
            $0.tab = .listening
        }
    }
}
