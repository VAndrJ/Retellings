//
//  AppView.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import AVFoundation
import ComposableArchitecture
import SwiftUI

@ViewAction(for: AppReducer.self)
struct AppView: View {
    @Bindable var store: StoreOf<AppReducer>

    @Environment(\.scenePhase) private var scenePhase
    @State private var tabBarHeight: CGFloat = .zero

    var body: some View {
        ZStack {
            switch store.status {
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
                TabView(selection: $store.tab) {
                    ListeningView(store: store.scopes.listeningSummary)
                        .toolbar(.hidden, for: .tabBar)
                        .tag(RetellingTab.listening)
                        .safeAreaInset(edge: .bottom) {
                            Spacer()
                                .frame(height: tabBarHeight)
                        }

                    ReadingView(store: store.scopes.readingSummary)
                        .toolbar(.hidden, for: .tabBar)
                        .tag(RetellingTab.overview)
                        .safeAreaInset(edge: .bottom) {
                            Spacer()
                                .frame(height: tabBarHeight)
                        }
                }
                // With .page style even worse.
                .safeAreaInset(edge: .bottom) {
                    CustomTabBar(
                        tabs: RetellingTab.allCases,
                        selection: $store.tab
                    )
                    .read(height: $tabBarHeight)
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: store.status)
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                // TODO: - Proper setup
                let session = AVAudioSession.sharedInstance()
                if session.category != .playback {
                    try? session.setCategory(.playback, mode: .spokenAudio)
                    try? session.setActive(true)
                }
            }
        }
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppReducer.State(
                listeningSummary: .init(player: .init()),
                readingSummary: .init()
            )
        ) {
            AppReducer()
        }
    )
}
