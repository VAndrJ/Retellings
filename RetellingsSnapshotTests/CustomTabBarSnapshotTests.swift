//
//  CustomTabBarSnapshotTests.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import XCTest
import SnapshotTesting
@testable import Retellings

final class CustomTabBarSnapshotTests: XCTestCase {

    // Just using the RetellingTab I already have.
    func test_speedControlView_Listening() {
        assertSnapshotWithDifferentUserInterfaceStyles(
            of: CustomTabBar(
                tabs: RetellingTab.allCases,
                selection: .constant(.listening)
            ).padding().embeddedForSnapshot
        )
    }

    func test_speedControlView_Overview() {
        assertSnapshotWithDifferentUserInterfaceStyles(
            of: CustomTabBar(
                tabs: RetellingTab.allCases,
                selection: .constant(.overview)
            ).padding().embeddedForSnapshot
        )
    }
}
