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
        TabView(selection: $store.state.tab) {
            Button("overview") {
                send(.select(tab: .overview))
            }
            .toolbar(.hidden, for: .tabBar)
            .tag(RetellingTab.listening)
            Button("listening") {
                send(.select(tab: .listening))
            }
            .toolbar(.hidden, for: .tabBar)
            .tag(RetellingTab.overview)
        }
        .safeAreaInset(edge: .bottom) {
            CustomTabBar(
                tabs: RetellingTab.allCases,
                selection: $store.tab
            )
        }
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppReducer.State()) {
            AppReducer()
        }
    )
}
