//
//  Observable.swift
//  ReactivePlayground-ios
//
//  Created by Ivan Misuno on 21/04/2020.
//  Copyright © 2020 AlbumPrinter. All rights reserved.
//

import Foundation

/// A push-style sequence.
/// The sequence can be subscribed to to receive events.
protocol ObservableType {
    associatedtype Element
    typealias Observer = (Element) -> ()
    func subscribe(onNext: @escaping Observer) -> Disposable
}
