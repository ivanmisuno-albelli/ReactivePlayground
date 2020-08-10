//
//  AnonymousDisposable.swift
//  ReactivePlayground-ios
//
//  Created by Ivan Misuno on 21/04/2020.
//  Copyright © 2020 AlbumPrinter. All rights reserved.
//

import Foundation

final class AnonymousDisposable: Disposable {
    private let lock = NSRecursiveLock()
    private var disposeBlock: ((Disposable) -> ())?

    /// Disposable initializer.
    ///
    /// - Parameter disposeBlock: Closure to be called when disposing (stored as a strong reference; released after a call to `dispose()`).
    init(_ disposeBlock: @escaping (Disposable) -> ()) {
        self.disposeBlock = disposeBlock
    }

    deinit {
        assert(isDisposed, "Disposable being deallocated while still not disposed!")
    }

    // MARK: - Disposable

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

extension Disposables {
    /// Create an anonymous disposable.
    /// - Parameter disposeBlock: Closure to be called when disposing (stored as a strong reference; released after a call to `dispose()`).
    static func create(_ disposeBlock: @escaping (Disposable) -> ()) -> Disposable {
        AnonymousDisposable(disposeBlock)
    }
}
