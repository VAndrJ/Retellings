//
//  KeyPointsView.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import SwiftUI

struct KeyPointsView: View {
    let current: Int
    let total: Int

    var body: some View {
        Text(L.keyPointValue(current, total))
            .foregroundStyle(.secondary)
            .dynamicFont(.inter, size: 16, weight: .semibold)
            .clampingDynamicTypeSize()
    }
}

#Preview {
    KeyPointsView(current: 2, total: 10)
}
