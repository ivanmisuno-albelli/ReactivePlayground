//
//  Disposable.swift
//  ReactivePlayground-ios
//
//  Created by Ivan Misuno on 21/04/2020.
//  Copyright © 2020 AlbumPrinter. All rights reserved.
//

import Foundation

/// Disposable is responsible for terminating the subscription to an event stream.
protocol Disposable {
    var isDisposed: Bool { get }
    func dispose()
}
