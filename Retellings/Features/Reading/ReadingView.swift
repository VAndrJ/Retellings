//
//  ReadingView.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: ReadingReducer.self)
struct ReadingView: View {
    @Bindable var store: StoreOf<ReadingReducer>

    var body: some View {
        ScrollView {
            switch store.state.status {
            case .idle:
                LargeProgressView()
            case let .data(text):
                Text(text)
                    .dynamicFont(.inter, size: 17)
                    .clampingDynamicTypeSize()
            }
        }
    }
}

#Preview {
    ReadingView(
        store: Store(initialState: ReadingReducer.State(status: .data("Hello, World!"))) {
            ReadingReducer()
        }
    )
}
