//
//  EmptyDisposable.swift
//  ReactivePlayground-ios
//
//  Created by Ivan Misuno on 21/04/2020.
//  Copyright © 2020 AlbumPrinter. All rights reserved.
//

import Foundation

final class EmptyDisposable: Disposable {

    init() {
    }

    // MARK: - Disposable

    private(set) var isDisposed: Bool = false

    func dispose() {
        isDisposed = true
    }
}

extension Disposables {
    /// Create an empty disposable. Empty disposable does nothing on disposal.
    static func create() -> Disposable {
        EmptyDisposable()
    }
}
