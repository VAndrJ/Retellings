//
//  Tests+Support.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import SnapshotTesting
import SwiftUI

extension View {
    var embeddedForSnapshot: UIHostingController<Self> {
        let controller = UIHostingController(rootView: self)
        controller.sizingOptions = .intrinsicContentSize

        return controller
    }
}

func assertSnapshotWithDifferentUserInterfaceStyles(
    of value: UIViewController,
    record recording: Bool? = nil,
    timeout: TimeInterval = 5,
    fileID: StaticString = #fileID,
    file filePath: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line,
    column: UInt = #column
) {
    [UIUserInterfaceStyle.light, .dark].forEach { style in
        UIContentSizeCategory.all.enumerated().forEach { index, size in
            assertSnapshot(
                of: value,
                as: .image(
                    traits: UITraitCollection { mutableTraits in
                        mutableTraits.preferredContentSizeCategory = size
                        mutableTraits.userInterfaceStyle = style
                    }),
                named: "_\(style)_\(index)_\(size)",
                record: recording,
                timeout: timeout,
                fileID: fileID,
                file: filePath,
                testName: testName,
                line: line,
                column: column
            )
        }
    }
}

extension UIContentSizeCategory {
    static let all: [UIContentSizeCategory] = [
        .small,
        .medium,
        .large,
        .extraLarge,
        .extraExtraLarge,
        .extraExtraExtraLarge,
        .accessibilityMedium,
    ]
}
