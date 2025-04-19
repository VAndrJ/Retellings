//
//  RetellingsApp.swift
//  Retellings
//
//  Created by VAndrJ on 4/18/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct RetellingsApp: App {
    var body: some Scene {
        WindowGroup {
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
    }
}
