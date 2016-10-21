//
//  Future.swift
//  Created by Vadim Pavlov on 23.07.16.

import Foundation

public enum Result<T, E: Error> {
	case success(T)
	case error(E)
}
public enum NoError: Error { }

public struct Future<T, E: Error> {
	public typealias ResultType = Result<T, E>

	public typealias Operation = (@escaping Completion) -> Cancellation?
	public typealias Completion = (ResultType) -> Void
	public typealias Cancellation = (Void) -> Void
	
	public let operation: Operation
	
	public init(_ operation: @escaping Operation) {
		self.operation = operation
	}

    @discardableResult
	public func start(_ completion: @escaping Completion) -> Cancellation? {
		return self.operation() { result in
			completion(result)
		}
	}
	public func map<U>(_ f: @escaping (T) -> U) -> Future<U, E> {
		return Future<U, E> ({ completion in
			return self.start { result in
				switch result {
				case .success(let value): completion(Result.success(f(value)))
                case .error(let error): completion(Result.error(error))
				}
			}
		})
	}
	
	public func flatMap<U>(_ f: @escaping (T) -> Future<U, E>) -> Future<U, E> {
		return Future<U, E>({ completion in
			return self.start { firstFutureResult in
				switch firstFutureResult {
				case .success(let value): f(value).start(completion)
                case .error(let error): completion(Result.error(error))
				}
			}
		})
	}
}
