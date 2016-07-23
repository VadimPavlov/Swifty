//
//  Sequence.swift
//  Created by Vadim Pavlov on 23.07.16.

import Foundation
public extension SequenceType {
	public func first(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Generator.Element? {
		for e in self where try predicate(e) {
			return e
		}
		return nil
	}
}