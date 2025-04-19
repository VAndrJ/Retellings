//
//  ListeningView.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: ListeningReducer.self)
struct ListeningView: View {
    @Bindable var store: StoreOf<ListeningReducer>

    var body: some View {
        switch store.status {
        case .idle, .loading:
            LargeProgressView()
        case let .loadingFailed(error):
            AppErrorView(error: error) {
                send(.tryLoadAgain)
            }
        case let .data(summary):
            VStack {
                CoverImageView(url: summary.url)
                    .fixedAspectRatio(2 / 3, contentMode: .fit)
                    .padding(.horizontal, 64)
                Spacer(minLength: 24)
                KeyPointsView(current: store.currentKeyPoint, total: store.total)
                    .padding(.bottom, 4)
                ChapterDescriptionView(text: store.currentTitle)
                    .padding(.bottom, 8)
                TimeControlView(currentTime: store.currentTime, duration: store.duration) {
                    send(.seek(to: $0))
                }
                SpeedControlView(speed: store.speed) {
                    send(.updateSpeed($0))
                }
                .padding(.bottom, 16)
                PlayerControlsView(store: store)
                    .padding(.bottom, 32)
            }
            .padding()
            .background(Color(.playerBackground))
        }
    }
}

#Preview {
    ListeningView(store: Store(initialState: ListeningReducer.State(status: .data(.test))) {
        ListeningReducer()
    })
}
