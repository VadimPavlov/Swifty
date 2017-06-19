//
//  Future.swift
//  Created by Vadim Pavlov on 23.07.16.

import Foundation

public struct Future<T> {
    
    public typealias Completion = (Result<T>) -> Void
    public typealias Cancellation = () -> Void
    public typealias Operation = (@escaping Completion) -> Cancellation?
    
    public let operation: Operation
    
    public init(_ operation: @escaping Operation) {
        self.operation = operation
    }
}

public extension Future {
    
    @discardableResult
    func start(completion: @escaping Completion) -> Cancellation? {
        return self.operation() { result in
            completion(result)
        }
    }
    
    @discardableResult
    func onSuccess(completion: @escaping (T) -> Void) -> Cancellation? {
        return self.start { result in
            if case .success(let value) = result {
                completion(value)
            }
        }
    }
    
    @discardableResult
    func onError(completion: @escaping (Error) -> Void)-> Cancellation? {
        return self.start { result in
            if case .error(let error) = result {
                completion(error)
            }
        }
    }
    
    func map<U>(f: @escaping (T) -> U) -> Future<U> {
        return Future<U> ({ completion in
            return self.start { result in
                switch result {
                case .success(let value): completion(Result.success(f(value)))
                case .error(let error): completion(Result.error(error))
                }
            }
        })
    }
    
    func flatMap<U>(f: @escaping (T) -> Future<U>) -> Future<U> {
        return Future<U>({ completion in
            return self.start { firstFutureResult in
                switch firstFutureResult {
                case .success(let value): f(value).start(completion: completion)
                case .error(let error): completion(Result.error(error))
                }
            }
        })
    }
    
    static func just(_ result: T) -> Future<T> {
        return Future { completion in
            completion(.success(result))
            return nil
        }
    }
    
    static func error(_ error: Error) -> Future<T> {
        return Future { completion in
            completion(.error(error))
            return nil
        }
        
    }
}

