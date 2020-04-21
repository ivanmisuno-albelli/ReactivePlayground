//
//  ProducingStreamTests.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 22/11/2017.
//

import XCTest
@testable import ReactivePlayground

class ProducingStreamTests: XCTestCase {

    var stream: ProducingStream_DEPRECATED<String>!
    var observers: [(String) -> ()] = []

    override func setUp() {
        stream = ProducingStream_DEPRECATED(producer: { (observer: @escaping (String) -> ()) -> Disposing_DEPRECATED in
            self.observers.append(observer)
            return NotDisposable_DEPRECATED()
        })
    }

    func test_ProducingStream_init_doesNotCallProducer() {
        XCTAssertEqual(observers.count, 0)
    }

    func test_ProducingStream_observeNext_callsProducer() {
        let disposable = stream.observeNext { _ in
        }
        defer { disposable.dispose() }

        XCTAssertEqual(observers.count, 1)

        let disposable2 = stream.observeNext { _ in
        }
        defer { disposable2.dispose() }

        XCTAssertEqual(observers.count, 2)

    }
}
