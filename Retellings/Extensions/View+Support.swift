//
//  View+Support.swift
//  Retellings
//
//  Created by VAndrJ on 4/18/25.
//

import SwiftUI

extension View {

    @inlinable
    nonisolated public func frame(
        same: CGFloat,
        alignment: Alignment = .center
    ) -> some View {
        frame(
            width: same,
            height: same,
            alignment: alignment
        )
    }

    @inlinable
    nonisolated public func clampingDynamicTypeSize(
        lowerBound: DynamicTypeSize = .medium,
        upperBound: DynamicTypeSize = .xxxLarge
    ) -> some View {
        dynamicTypeSize(lowerBound...upperBound)
    }

    func framedAspectRatio(
        _ aspect: CGFloat? = nil,
        contentMode: ContentMode
    ) -> some View where Self == Image {
        self.resizable()
            .fixedAspectRatio(contentMode: contentMode)
    }

    func fixedAspectRatio(
        _ aspect: CGFloat? = nil,
        contentMode: ContentMode
    ) -> some View {
        self.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .aspectRatio(aspect, contentMode: contentMode)
            .clipped()
    }
}
