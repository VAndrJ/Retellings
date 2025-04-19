//
//  LargeProgressView.swift
//  Retellings
//
//  Created by VAndrJ on 4/18/25.
//

import SwiftUI

struct LargeProgressView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .controlSize(.large)
            .clampingDynamicTypeSize()
    }
}

#Preview {
    LargeProgressView()
}
