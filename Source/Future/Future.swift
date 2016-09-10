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
	public typealias ResultType = Result<T, E>

	public typealias Operation = Completion -> Cancellation?
	public typealias Completion = ResultType -> Void
	public typealias Cancellation = Void -> Void
	
	public let operation: Operation
	
	public init(_ operation: Operation) {
		self.operation = operation
	}
	
	public func start(completion: Completion) -> Cancellation? {
		return self.operation() { result in
			completion(result)
		}
	}
	public func map<U>(f: T -> U) -> Future<U, E> {
		return Future<U, E> ({ completion in
			return self.start { result in
				switch result {
				case .Success(let value): completion(Result.Success(f(value)))
				case .Error(let error): completion(Result.Error(error))
				}
			}
		})
	}
	
	public func flatMap<U>(f: T -> Future<U, E>) -> Future<U, E> {
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
