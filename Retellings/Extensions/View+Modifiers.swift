//
//  View+Modifiers.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import SwiftUI

extension View {
    func read(height: Binding<CGFloat>) -> some View {
        modifier(HeightReader(height: height))
    }
}

private struct HeightReader: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            height = proxy.size.height
                        }
                        .onChange(of: proxy.size.height) { old, new in
                            guard old != new else { return }

                            height = new
                        }
                }
            )
    }
}
