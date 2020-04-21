//
//  Observable_DEPRECATED.swift
//  ReactivePlayground
//
//  Created by Ivan Misuno on 16/11/2017.
//

import Foundation

protocol Observable_DEPRECATED {
    associatedtype EventType
    typealias Observer = (EventType) -> ()
    func observeNext(_ observer: @escaping Observer) -> Disposing_DEPRECATED
}

/// Helper class to manage the list of observers.
final class ObserverList_DEPRECATED<EventType> {
    typealias Observer = (EventType) -> ()

    private let lock = NSRecursiveLock()
    private var observers: [(Disposing_DEPRECATED, Observer)] = []

    /// Add observer to the list.
    ///
    /// - Parameter observer: Observer closure to be called when new event arrives.
    ///                       Strong reference to the closure is stored.
    /// - Returns: A dispose handle. Internally, the dispose handle references `self` strongly,
    ///                       creating reference cycle. Don't forget to call `dispose()` on it.
    func add(observer: @escaping Observer) -> Disposing_DEPRECATED {
        lock.lock()
        defer { lock.unlock() }
        let disposable = Disposable_DEPRECATED { (disposable: Disposing_DEPRECATED) in
            self.remove(disposable: disposable)
        }
        observers.append((disposable, observer))
        return disposable
    }

    /// Remove disposable from the list.
    ///
    /// - Parameter disposable: A dispose handle to be removed. No more cyclic references after this point.
    func remove(disposable: Disposing_DEPRECATED) {
        lock.lock()
        defer { lock.unlock() }
        observers = observers.filter { $0.0 !== disposable }
    }

    /// Iterate over the list of observers, passing each to the supplied block.
    ///
    /// - Parameter block: A block to be invoked with each of the stored observers.
    func forEach(block: (Observer) -> ()) {
        lock.lock()
        let copy = observers
        lock.unlock()

        copy.forEach { (_, observer) in
            block(observer)
        }
    }
}
