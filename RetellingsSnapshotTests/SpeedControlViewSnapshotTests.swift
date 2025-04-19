//
//  SpeedControlViewSnapshotTests.swift
//  RetellingsSnapshotTests
//
//  Created by VAndrJ on 4/18/25.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import Retellings

final class SpeedControlViewSnapshotTests: XCTestCase {

    func test_speedControlView_DefaultState() {
        assertSnapshotWithDifferentUserInterfaceStyles(
            of: SpeedControlView(speed: 1) { _ in }.padding().embeddedForSnapshot
        )
    }

    // Same for other values/Views depending on needs.
}

// Crash: Retellings (18665) closure #1 in static Snapshotting<>...
// @Suite(.snapshots(record: .missing, diffTool: .ksdiff))
// struct SpeedControlViewSnapshotTests {
//
//    @Test
//    func speedControlView_DefaultState() async throws {
