//
//  DisposableTests.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 17/11/2017.
//

import XCTest
@testable import ReactivePlayground

class DisposableTests: XCTestCase {

    // MARK: - Disposable

    func test_initiallyNotDisposed() {
        let disposable = Disposable({_ in})
        XCTAssertFalse(disposable.isDisposed)
        disposable.dispose() // must explicitly cleanup
    }

    // Testing that a method results in an assertionFailure is not directly possible in XCTest.
    // https://github.com/mattgallagher/CwlPreconditionTesting adds support for testing that assertion was invoked.
//    func test_deallocating_whenNotDisposed_asserts() {
//        var disposable: Disposing? = Disposable({_ in})
//        disposable = nil
//    }

    func test_dispose_makesItDisposed() {
        let disposable = Disposable({_ in})
        disposable.dispose()
        XCTAssertTrue(disposable.isDisposed)
    }

    func test_dispose_invokesDisposeClosure() {
        var disposeClosureInvoked = false
        let disposable = Disposable({_ in disposeClosureInvoked = true })
        disposable.dispose()
        XCTAssertTrue(disposeClosureInvoked)
    }

    func test_dispose_invokesDisposeOnlyOnce() {
        var disposeClosureInvocationCount = 0
        let disposable = Disposable({_ in disposeClosureInvocationCount += 1 })
        disposable.dispose()
        disposable.dispose()
        XCTAssertEqual(disposeClosureInvocationCount, 1)
    }


    // MARK: - ScopedDisposable

    func test_scopedDisposable_initiallyNotDisposed() {
        let disposable = Disposable({_ in}).asScopedDisposable
        XCTAssertFalse(disposable.isDisposed)
    }

    func test_scopedDisposable_isDisposed() {
        let disposable = Disposable({_ in}).asScopedDisposable
        disposable.dispose()
        XCTAssertTrue(disposable.isDisposed)
    }

    func test_scopedDisposable_disposed() {
        var disposeClosureInvoked = false
        let disposable = Disposable({_ in disposeClosureInvoked = true }).asScopedDisposable
        disposable.dispose()
        XCTAssertTrue(disposeClosureInvoked)
    }

    func test_scopedDisposable_disposedOnDealloc() {
        var disposeClosureInvoked = false
        autoreleasepool {
            _ = Disposable({_ in disposeClosureInvoked = true }).asScopedDisposable
        }
        XCTAssertTrue(disposeClosureInvoked)
    }
}
