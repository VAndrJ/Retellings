//
//  CustomTabBar.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import SwiftUI

enum RetellingTab: CaseIterable {
    case listening
    case overview
}

extension RetellingTab: TabItem {
    var icon: String {
        switch self {
        case .listening: "headphones"
        case .overview: "list.bullet"
        }
    }
}

protocol TabItem {
    var icon: String { get }
}

struct CustomTabBar<T: Hashable & TabItem>: View {
    let tabs: [T]
    @Binding var selection: T

    @Namespace private var circle

    var body: some View {
        HStack(spacing: 8) {
            ForEach(tabs, id: \.self) { tab in
                ZStack {
                    if selection == tab {
                        Circle()
                            .fill(.blue)
                            .frame(same: 44)
                            .matchedGeometryEffect(id: circle, in: circle)
                    }
                    Button {
                        selection = tab
                    } label: {
                        Image(systemName: tab.icon)
                            .font(.title2)
                            .foregroundColor(selection == tab ? .white : .gray)
                    }
                    .frame(same: 44)
                    .buttonStyle(.plain)
                    .clipShape(.circle)
                }
                .contentShape(.circle)
            }
            .animation(.easeIn(duration: 0.2), value: selection)
        }
        .padding(4)
        .background(.background)
        .clipShape(.capsule)
        .shadow(color: .primary.opacity(0.33), radius: 4)
        .clampingDynamicTypeSize()
    }
}

#Preview {
    @Previewable @State var selectedTab: RetellingTab = .listening

    CustomTabBar(tabs: RetellingTab.allCases, selection: $selectedTab)
}
