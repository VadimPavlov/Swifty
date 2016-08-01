//
//  Future.swift
//  Created by Vadim Pavlov on 23.07.16.

import Foundation

public enum Result<T, E: ErrorType> {
	case Success(T)
	case Error(E)
}
public enum NoError: ErrorType { }

public struct Future<T, E: ErrorType> {
	typealias ResultType = Result<T, E>

	typealias Operation = Completion -> Cancellation?
	typealias Completion = ResultType -> Void
	typealias Cancellation = Void -> Void
	
	private let operation: Operation
	
	init(_ operation: Operation) {
		self.operation = operation
	}
	
	func start(completion: Completion) -> Cancellation? {
		return self.operation() { result in
			completion(result)
		}
	}
	func map<U>(f: T -> U) -> Future<U, E> {
		return Future<U, E> ({ completion in
			return self.start { result in
				switch result {
				case .Success(let value): completion(Result.Success(f(value)))
				case .Error(let error): completion(Result.Error(error))
				}
			}
		})
	}
	
	func flatMap<U>(f: T -> Future<U, E>) -> Future<U, E> {
		return Future<U, E>({ completion in
			return self.start { firstFutureResult in
				switch firstFutureResult {
				case .Success(let value): f(value).start(completion)
				case .Error(let error): completion(Result.Error(error))
				}
			}
		})
	}
}
