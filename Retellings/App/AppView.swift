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
            .tag(RetellingTab.listening)
            Button("listening") {
                send(.select(tab: .listening))
            }
            .tag(RetellingTab.overview)
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
