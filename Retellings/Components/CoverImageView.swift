//
//  CoverImageView.swift
//  Retellings
//
//  Created by VAndrJ on 4/18/25.
//

import SwiftUI

struct CoverImageView: View {
    let url: URL

    var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if phase.error != nil {
                Image(.placeholderSmallNormal)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
}

#Preview {
    CoverImageView(url: URL(string: "google.com")!)
        .frame(same: 100)

    CoverImageView(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/PNG_transparency_demonstration_1.png/640px-PNG_transparency_demonstration_1.png")!)
        .frame(same: 100)
        .clipped()
}
