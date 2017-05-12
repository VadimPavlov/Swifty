//
//  Future.swift
//  Created by Vadim Pavlov on 23.07.16.

import Foundation

public struct Future<T> {
	public typealias ResultType = Result<T>

	public typealias Operation = (Completion) -> Cancellation?
	public typealias Completion = (ResultType) -> Void
	public typealias Cancellation = () -> Void
	
	public let operation: Operation
	
	public init(_ operation: @escaping Operation) {
		self.operation = operation
	}
	
    @discardableResult
	public func start(completion: Completion) -> Cancellation? {
		return self.operation() { result in
			completion(result)
		}
	}
    
	public func map<U>(f: @escaping (T) -> U) -> Future<U> {
		return Future<U> ({ completion in
			return self.start { result in
				switch result {
				case .success(let value): completion(Result.success(f(value)))
				case .error(let error): completion(Result.error(error))
				}
			}
		})
	}
    
	public func flatMap<U>(f: @escaping (T) -> Future<U>) -> Future<U> {
		return Future<U>({ completion in
			return self.start { firstFutureResult in
				switch firstFutureResult {
				case .success(let value): f(value).start(completion: completion)
				case .error(let error): completion(Result.error(error))
				}
			}
		})
	}
}
