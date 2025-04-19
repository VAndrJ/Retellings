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
    func tabSelection_ChangesAppState() async {
        let store = await TestStore(
            initialState: AppReducer.State(
                listeningSummary: .init(player: .init()),
                readingSummary: .init()
            )
        ) {
            AppReducer()
        }

        await store.send(.view(.select(tab: .overview))) {
            $0.tab = .overview
        }
        await store.send(.view(.select(tab: .listening))) {
            $0.tab = .listening
        }
    }

    @Test("Failure status when error occured during data loading")
    func dataLoad_Failure_ChangesAppState() async {
        let store = await TestStore(
            initialState: AppReducer.State(
                listeningSummary: .init(player: .init()),
                readingSummary: .init()
            )
        ) {
            AppReducer()
        } withDependencies: { dependency in
            dependency.apiClient = .init(
                fetchSummary: {
                    throw APIClient.Failure()
                },
                fetchAudiosList: { _ in .test }
            )
        }

        await store.send(.effect(.fetchData)) {
            $0.status = .loading
        }
        await store.receive(\.effect.fetchDataResult) {
            $0.status = .loadingFailed(.summaryLoadingFailed)
        }
    }

    @Test("Sucess status when data loaded")
    func dataLoad_Success_ChangesAppState() async {
        let expected = BookSummary.test
        let store = await TestStore(
            initialState: AppReducer.State(
                listeningSummary: .init(player: .init()),
                readingSummary: .init()
            )
        ) {
            AppReducer()
        } withDependencies: { dependency in
            dependency.apiClient = .init(
                fetchSummary: { expected },
                fetchAudiosList: { _ in .test }
            )
        }

        await store.send(.effect(.fetchData)) {
            $0.status = .loading
        }
        await store.receive(\.effect.fetchDataResult) {
            $0.status = .data(expected)
            $0.readingSummary.status = .data(expected.about)
        }
        await store.skipReceivedActions()
    }

    // TODO: - other scenarios
}
