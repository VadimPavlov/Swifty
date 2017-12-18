//
//  BatchFuture.swift
//  Swifty
//
//  Created by Vadim Pavlov on 12/18/17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public struct BatchFutures<T> {

    public let futures: [Future<T>]

    public enum ErrorHandling {
        case fail       // Fail Batch Future on first error
        case ignore     // Keep running
    }

    public func future(onError: ErrorHandling) -> Future<[T]> {
        return Future { completion in
            var results: [T] = []
            let group = DispatchGroup()
            let mainProgress = Progress(totalUnitCount: Int64(self.futures.count))

            self.futures.forEach { future in
                group.enter()
                let childProgress = future.start { result in
                    switch result {
                    case .success(let value):
                        results.append(value)
                    case .error(let error):
                        if onError == .fail {
                            completion(.error(error))
                        }
                    }
                    group.leave()
                }
                if let progress = childProgress {
                    mainProgress.addChild(progress, withPendingUnitCount: 1)
                }
            }

            group.notify(queue: .main) {
                completion(.success(results))
            }
            return mainProgress
        }
    }
}

