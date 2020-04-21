//
//  ObservableMapTests.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 22/11/2017.
//

import XCTest
@testable import ReactivePlayground

class ObservableMapTests: XCTestCase {

    let stream = PushStream_DEPRECATED<Int>()
    var observation: Disposing_DEPRECATED?
    var observedString: String?

    override func setUp() {
        super.setUp()
        observation = stream
            .map { (value: Int) -> String in
                return String(value)
            }
            .observeNext { (value: String) in
                self.observedString = value
            }
    }

    override func tearDown() {
        super.tearDown()
        observation?.dispose()
    }

    func test_map() {
        XCTAssertNil(observedString)

        stream.next(1)
        XCTAssertEqual(observedString, "1")

        stream.next(2)
        XCTAssertEqual(observedString, "2")
    }

}
