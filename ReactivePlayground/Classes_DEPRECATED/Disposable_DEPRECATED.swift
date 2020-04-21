//
//  Disposable_DEPRECATED.swift
//  ReactivePlayground
//
//  Created by Ivan Misuno on 16/11/2017.
//

protocol Disposing_DEPRECATED: class {
    var isDisposed: Bool { get }
    func dispose()
}

/// Disposable_DEPRECATED is responsible for terminating the subscription to an event stream.
final class Disposable_DEPRECATED: Disposing_DEPRECATED {
    private let lock = NSRecursiveLock()
    private var disposeBlock: ((Disposable_DEPRECATED) -> ())?

    /// Disposable_DEPRECATED initializer.
    ///
    /// - Parameter disposeBlock: Closure to be called when disposing. Stored as a strong reference.
    init(_ disposeBlock: @escaping (Disposable_DEPRECATED) -> ()) {
        self.disposeBlock = disposeBlock
    }

    deinit {
        assert(isDisposed, "Disposable_DEPRECATED being deallocated while still not disposed!")
    }

    // MARK: - Disposing_DEPRECATED

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
final class ScopedDisposable_DEPRECATED: Disposing_DEPRECATED {
    private let disposable: Disposing_DEPRECATED
    init(with disposable: Disposing_DEPRECATED) {
        self.disposable = disposable
    }
    deinit {
        dispose()
    }
    // MARK: - Disposing_DEPRECATED
    var isDisposed: Bool {
        return disposable.isDisposed
    }
    func dispose() {
        disposable.dispose()
    }
}

extension Disposing_DEPRECATED {
    var asScopedDisposable: Disposing_DEPRECATED {
        return ScopedDisposable_DEPRECATED(with: self)
    }
}

/// Stub to be used when no resources need to be freed.
final class NotDisposable_DEPRECATED: Disposing_DEPRECATED {
    // MARK: - SubscriptionDisposing
    var isDisposed: Bool { return false }
    func dispose() {}
}
