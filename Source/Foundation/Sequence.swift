//
//  Sequence.swift
//  Created by Vadim Pavlov on 23.07.16.

import Foundation

public extension Sequence {
    
    func categorise<U : Hashable>(keyFunc: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}
