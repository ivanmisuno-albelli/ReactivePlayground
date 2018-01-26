//
//  Observable.swift
//  ReactivePlayground
//
//  Created by Ivan Misuno on 16/11/2017.
//

protocol Observable {
    associatedtype EventType
    typealias Observer = (EventType) -> ()
    func observeNext(_ observer: @escaping Observer) -> Disposing
}

/// Helper class to manage the list of observers.
final class ObserverList<EventType> {
    typealias Observer = (EventType) -> ()

    private let lock = NSRecursiveLock()
    private var observers: [(Disposing, Observer)] = []

    /// Add observer to the list.
    ///
    /// - Parameter observer: Observer closure to be called when new event arrives.
    ///                       Strong reference to the closure is stored.
    /// - Returns: A dispose handle. Internally, the dispose handle references `self` strongly,
    ///                       creating reference cycle. Don't forget to call `dispose()` on it.
    func add(observer: @escaping Observer) -> Disposing {
        lock.lock()
        defer { lock.unlock() }
        let disposable = Disposable { (disposable: Disposing) in
            self.remove(disposable: disposable)
        }
        observers.append((disposable, observer))
        return disposable
    }

    /// Remove disposable from the list.
    ///
    /// - Parameter disposable: A dispose handle to be removed. No more cyclic references after this point.
    func remove(disposable: Disposing) {
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
