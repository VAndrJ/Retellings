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
}
