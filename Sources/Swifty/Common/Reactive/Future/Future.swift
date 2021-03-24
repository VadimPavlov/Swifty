//
//  Future.swift
//  Created by Vadim Pavlov on 23.07.16.

import Foundation

public struct Future<T> {

    public typealias Completion = (Result<T>) -> Void
    public typealias Task = (@escaping Completion) -> Progress?

    public let task: Task

    public enum CompletionQueue {
        case result
        case main
        case current
    }

    public init(_ task: @escaping Task) {
        self.task = task
    }

    public static func success(_ result: T) -> Future<T> {
        return Future { completion in
            completion(.success(result))
            return nil
        }
    }

    public static func error(_ error: Error) -> Future<T> {
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
    func start(queue: CompletionQueue = .result, completion: @escaping Completion) -> Progress? {

        let main = OperationQueue.main
        let current = OperationQueue.current ?? .main

        return self.task() { result in
            switch queue {
            case .result:
                completion(result)
            case .main:
                main.addOperation { completion(result) }
            case .current:
                current.addOperation { completion(result) }
            }
        }
    }

    @discardableResult
    func onSuccess(queue: CompletionQueue = .result, completion: @escaping (T) -> Void) -> Progress? {
        return self.start(queue: queue) { result in
            if case .success(let value) = result {
                completion(value)
            }
        }
    }

    @discardableResult
    func onError(queue: CompletionQueue = .result, completion: @escaping (Error) -> Void)-> Progress? {
        return self.start(queue: queue) { result in
            if case .error(let error) = result {
                completion(error)
            }
        }
    }

    func map<U>(queue: CompletionQueue = .result, f: @escaping (T) -> U) -> Future<U> {
        return Future<U> ({ completion in
            return self.start(queue: queue) { result in
                switch result {
                case .success(let value): completion(Result.success(f(value)))
                case .error(let error): completion(Result.error(error))
                }
            }
        })
    }

    func mapError(queue: CompletionQueue = .result, f: @escaping (Error) -> Error) -> Future<T> {
        return Future ({ completion in
            return self.start(queue: queue) { result in
                switch result {
                case .success(let value): completion(Result.success(value))
                case .error(let error): completion(Result.error(f(error)))
                }
            }
        })
    }

    func flatMap<U>(queue: CompletionQueue = .result, f: @escaping (T) -> Future<U>) -> Future<U> {
        return Future<U>({ completion in
            return self.start(queue: queue) { firstFutureResult in
                switch firstFutureResult {
                case .success(let value): f(value).start(completion: completion)
                case .error(let error): completion(Result.error(error))
                }
            }
        })
    }
}
