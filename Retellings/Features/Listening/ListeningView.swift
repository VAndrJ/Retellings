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
        Text("Hello, world")
    }
}
