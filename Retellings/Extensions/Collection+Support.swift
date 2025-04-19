//
//  Collection+Support.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

extension Collection {

    /// O(n), but doesn't matter for small quantities
    func element(at index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}
