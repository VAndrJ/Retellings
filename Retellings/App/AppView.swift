//
//  AppView.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: AppReducer.self)
struct AppView: View {
    @Bindable var store: StoreOf<AppReducer>

    var body: some View {
        ZStack {
            switch store.state.status {
            case .idle:
                LargeProgressView()
                    .onAppear {
                        send(.onAppear)
                    }
            case .loading:
                LargeProgressView()
            case let .loadingFailed(error):
                AppErrorView(error: error) {
                    send(.tryAgain)
                }
            case .data:
                TabView(selection: $store.state.tab) {
                    ListeningView(store: store.scopes.listeningSummary)
                        .toolbar(.hidden, for: .tabBar)
                        .tag(RetellingTab.listening)

                    ReadingView(store: store.scopes.readingSummary)
                        .toolbar(.hidden, for: .tabBar)
                        .tag(RetellingTab.overview)
                }
                .safeAreaInset(edge: .bottom) {
                    CustomTabBar(
                        tabs: RetellingTab.allCases,
                        selection: $store.tab
                    )
                }
                .onAppear {
                    send(.onAppear)
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: store.status)
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppReducer.State(
                listeningSummary: .init(),
                readingSummary: .init()
            )
        ) {
            AppReducer()
        }
    )
}
