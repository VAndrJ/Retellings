//
//  AppErrorView.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import SwiftUI

struct AppErrorView: View {
    let error: MyAwesomeError
    let action: () -> Void

    var body: some View {
        VStack {
            Text(error.localizedDescription)
            Button(L.tryAgain(), action: action)
        }
        .dynamicFont(.inter, size: 20)
        .clampingDynamicTypeSize(upperBound: .accessibility2)
    }
}

#Preview {
    AppErrorView(error: .summaryLoadingFailed) {
        print("Action")
    }
}
