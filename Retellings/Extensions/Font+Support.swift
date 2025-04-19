//
//  Font+Support.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import SwiftUI

extension Font {
    enum Custom: String {
        case inter = "Inter"

        func getName(weight: Font.Weight) -> String {
            switch weight {
            case .bold: "\(rawValue)-Bold"
            case .semibold: "\(rawValue)-SemiBold"
            default: "\(rawValue)-Regular"
            }
        }
    }
}

extension View {

    func dynamicFont(_ name: Font.Custom, size: Double, weight: Font.Weight = .regular) -> some View {
        modifier(DynamicFont(name: name.getName(weight: weight), size: size))
    }
}

private struct DynamicFont: ViewModifier {
    @Environment(\.sizeCategory)
    private var sizeCategory
    var name: String
    var size: Double

    func body(content: Content) -> some View {
        content
            .font(.custom(name, size: UIFontMetrics.default.scaledValue(for: size)))
    }
}
