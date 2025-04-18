//
//  ChapterDescriptionView.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import SwiftUI

struct ChapterDescriptionView: View {
    let text: String

    var body: some View {
        Text(text)
            .multilineTextAlignment(.center)
            .foregroundStyle(.primary)
            .lineLimit(2)
            .dynamicFont(.inter, size: 16)
            .clampingDynamicTypeSize()
    }
}

#Preview {
    ChapterDescriptionView(
        text: "Design is not how a thing looks, but how it works"
    )
    .padding(.horizontal, 48)
}
