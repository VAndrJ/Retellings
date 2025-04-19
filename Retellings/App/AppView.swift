//
//  AppView.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .tag(RetellingTab.listening)
            Text("Hello, world!")
                .tag(RetellingTab.overview)
        }
    }
}

#Preview {
    AppView()
}
