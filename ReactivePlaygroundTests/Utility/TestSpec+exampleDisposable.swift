//
//  TestSpec+exampleDisposable.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 22/01/2018.
//

import Quick
@testable import ReactivePlayground

/// Enable following constructs from within unit tests:
/// override func spec() {
///    it("") {
///       anyObservable
///          .observeNext { _ in }
///          .disposed(afterEach: self)
///    }
/// }
///
/// NOTE: This works in assumption that tests are executed sequentially in the main thread!
///

private var __exampleDisposables: [Disposing] = []

class TestConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        configuration.afterEach {
            __exampleDisposables.forEach { $0.dispose() }
            __exampleDisposables.removeAll()
        }
    }
}

protocol ExampleDisposableBinding {
    func addExampleDisposable(_ disposable: Disposing)
}

extension TestSpec: ExampleDisposableBinding {
    func addExampleDisposable(_ disposable: Disposing) {
        __exampleDisposables.append(disposable)
    }
}

extension Disposing {
    func disposed(afterEach example: ExampleDisposableBinding) {
        return example.addExampleDisposable(self)
    }
}
