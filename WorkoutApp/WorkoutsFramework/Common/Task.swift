//
//  Task.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import Foundation


/// Curtosy of John Sundell https://www.swiftbysundell.com/articles/task-based-concurrency-in-swift/
class Task {
    enum Outcome {
        case success
        case failure(Error)
    }
    
    typealias Closure = (Controller) -> Void
    
    private let closure: Closure
    
    init(closure: @escaping Closure) {
        self.closure = closure
    }
    
    func perform(on queue: DispatchQueue = .global(), then handler: @escaping (Outcome) -> Void) {
        queue.async {
            let controller = Controller(
                queue: queue,
                handler: handler
            )
            
            self.closure(controller)
        }
    }
    
    struct Controller {
        let queue: DispatchQueue
        fileprivate let handler: (Outcome) -> Void
        
        func finish() {
            handler(.success)
        }
        
        func fail(with error: Error) {
            handler(.failure(error))
        }
    }
    
    static func group(_ tasks: [Task]) -> Task {
        return Task { controller in
            let group = DispatchGroup()
            
            let errorSyncQueue = DispatchQueue(label: "Task.ErrorSync")
            var anyError: Error?
            
            for task in tasks {
                group.enter()
                
                task.perform(on: controller.queue) { outcome in
                    switch outcome {
                    case .success:
                        break
                    case .failure(let error):
                        errorSyncQueue.sync {
                            anyError = anyError ?? error
                        }
                    }
                    
                    group.leave()
                }
            }
            
            group.notify(queue: controller.queue) {
                if let error = anyError {
                    controller.fail(with: error)
                } else {
                    controller.finish()
                }
            }
        }
    }
    
    static func sequence(_ tasks: [Task]) -> Task {
        var index = 0
        
        func performNext(using controller: Controller) {
            guard index < tasks.count else {
                controller.finish()
                return
            }
            
            let task = tasks[index]
            index += 1
            
            task.perform(on: controller.queue) { outcome in
                switch outcome {
                case .success:
                    performNext(using: controller)
                case .failure(let error):
                    controller.fail(with: error)
                }
            }
        }
        
        return Task(closure: performNext)
    }
}

