//
//  Future.swift
//  Created by Vadim Pavlov on 23.07.16.

import Foundation

public struct Future<T> {
    
    public typealias Completion = (Result<T>) -> Void
    public typealias Task = (@escaping Completion) -> Progress?
    
    public let task: Task
    
    public init(_ task: @escaping Task) {
        self.task = task
    }

    static func success(_ result: T) -> Future<T> {
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

public extension Future where T == Void {
    static var success: Future<Void> {
        return Future.success(())
    }
}

public extension Future {
    
    @discardableResult
    func start(completion: @escaping Completion) -> Progress? {
        return self.task() { result in
            completion(result)
        }
    }
    
    @discardableResult
    func onSuccess(completion: @escaping (T) -> Void) -> Progress? {
        return self.start { result in
            if case .success(let value) = result {
                completion(value)
            }
        }
    }
    
    @discardableResult
    func onError(completion: @escaping (Error) -> Void)-> Progress? {
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

    func mapError(f: @escaping (Error) -> Error) -> Future<T> {
        return Future ({ completion in
            return self.start { result in
                switch result {
                case .success(let value): completion(Result.success(value))
                case .error(let error): completion(Result.error(f(error)))
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
}
