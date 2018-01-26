//
//  Disposable.swift
//  ReactivePlayground
//
//  Created by Ivan Misuno on 16/11/2017.
//

protocol Disposing: class {
    var isDisposed: Bool { get }
    func dispose()
}

/// Disposable is responsible for terminating the subscription to an event stream.
final class Disposable: Disposing {
    private let lock = NSRecursiveLock()
    private var disposeBlock: ((Disposable) -> ())?

    /// Disposable initializer.
    ///
    /// - Parameter disposeBlock: Closure to be called when disposing. Stored as a strong reference.
    init(_ disposeBlock: @escaping (Disposable) -> ()) {
        self.disposeBlock = disposeBlock
    }

    deinit {
        assert(isDisposed, "Disposable being deallocated while still not disposed!")
    }

    // MARK: - Disposing

    var isDisposed: Bool {
        lock.lock()
        defer { lock.unlock() }
        return disposeBlock == nil
    }

    func dispose() {
        lock.lock()
        defer { lock.unlock() }
        guard let disposeBlockCopy = disposeBlock else {
            return
        }
        disposeBlock = nil
        disposeBlockCopy(self)
    }
}

/// Scoped disposable disposes of itself on deallocation, e.g., when execution leaves its enclosing scope.
final class ScopedDisposable: Disposing {
    private let disposable: Disposing
    init(with disposable: Disposing) {
        self.disposable = disposable
    }
    deinit {
        dispose()
    }
    // MARK: - Disposing
    var isDisposed: Bool {
        return disposable.isDisposed
    }
    func dispose() {
        disposable.dispose()
    }
}

extension Disposing {
    var asScopedDisposable: Disposing {
        return ScopedDisposable(with: self)
    }
}

/// Stub to be used when no resources need to be freed.
final class NotDisposable: Disposing {
    // MARK: - SubscriptionDisposing
    var isDisposed: Bool { return false }
    func dispose() {}
}
