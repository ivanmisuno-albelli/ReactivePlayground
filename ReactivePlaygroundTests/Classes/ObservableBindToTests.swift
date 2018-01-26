//
//  ObservableBindToTests.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 22/11/2017.
//

import XCTest
@testable import ReactivePlayground

class ObservableBindToTests: XCTestCase {

    let stream = PushStream<Int>()
    var observation: Disposing?
    let boundVariable = Variable<Int>(0)

    override func setUp() {
        super.setUp()
        observation = stream
            .bindTo(boundVariable)
        XCTAssertEqual(boundVariable.value, 0)
    }

    override func tearDown() {
        super.tearDown()
        observation?.dispose()
    }

    func test_boundVariable() {
        stream.next(1)
        XCTAssertEqual(boundVariable.value, 1)

        stream.next(2)
        XCTAssertEqual(boundVariable.value, 2)
    }

}
