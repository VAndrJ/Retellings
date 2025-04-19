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
        Text("Hello, world")
    }
}
