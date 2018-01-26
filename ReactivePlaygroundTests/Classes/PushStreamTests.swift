//
//  PushStreamTests.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 17/11/2017.
//

import XCTest
@testable import ReactivePlayground

class PushStreamTests: XCTestCase {

    let pushStream = PushStream<String>()

    func test_next_invokesAllObservers() {
        var observedString1: String? = nil
        let subscription1 = pushStream.observeNext { value in
            observedString1 = value
        }
        defer { subscription1.dispose() }

        var observedString2: String? = nil
        let subscription2 = pushStream.observeNext { value in
            observedString2 = value
        }
        defer { subscription2.dispose() }

        XCTAssertNil(observedString1)
        XCTAssertNil(observedString2)

        pushStream.next("a")
        XCTAssertEqual(observedString1, "a")
        XCTAssertEqual(observedString2, "a")
    }

    func test_next_afterSubscriptionIsDisposed_doesNotInvokeObserver() {
        var observedString1: String? = nil
        let subscription1 = pushStream.observeNext { value in
            observedString1 = value
        }

        var observedString2: String? = nil
        let subscription2 = pushStream.observeNext { value in
            observedString2 = value
        }

        pushStream.next("a")
        XCTAssertEqual(observedString1, "a")
        XCTAssertEqual(observedString2, "a")

        subscription1.dispose()

        pushStream.next("b")
        XCTAssertEqual(observedString1, "a")
        XCTAssertEqual(observedString2, "b")

        subscription2.dispose()

        pushStream.next("c")
        XCTAssertEqual(observedString1, "a")
        XCTAssertEqual(observedString2, "b")
    }
}
