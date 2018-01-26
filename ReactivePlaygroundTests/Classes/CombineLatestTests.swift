//
//  CombineLatestTests.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 22/11/2017.
//

import XCTest
@testable import ReactivePlayground

public func ==<A: Equatable, B: Equatable>(lhs: (A, B), rhs: (A, B)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}
public func ==<A: Equatable, B: Equatable>(lhs: (A, B)?, rhs: (A, B)) -> Bool {
    guard let lhs = lhs else { return false }
    return lhs == rhs
}

class CombineLatestTests: XCTestCase {
    let ints = PushStream<Int>()
    let strings = PushStream<String>()
    var combinedStream: Stream<(Int, String)>!
    var observation: Disposing!
    var observedCombinedValue: (Int, String)?

    override func setUp() {
        super.setUp()
        combinedStream = combineLatest(ints, strings)
        observation = combinedStream.observeNext { (value: (Int, String)) in
            self.observedCombinedValue = value
        }
        XCTAssertNil(observedCombinedValue)
    }

    override func tearDown() {
        super.tearDown()
        observation.dispose()
    }

    func test_combineLatest() {
        ints.next(1)
        XCTAssertNil(observedCombinedValue)

        strings.next("a")
        XCTAssertTrue(observedCombinedValue == (1, "a"))

        strings.next("b")
        XCTAssertTrue(observedCombinedValue == (1, "b"))

        ints.next(2)
        XCTAssertTrue(observedCombinedValue == (2, "b"))
    }
}

public func ==<A: Equatable, B: Equatable, C: Equatable>(lhs: (A, B, C), rhs: (A, B, C)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2
}
public func ==<A: Equatable, B: Equatable, C: Equatable>(lhs: (A, B, C)?, rhs: (A, B, C)) -> Bool {
    guard let lhs = lhs else { return false }
    return lhs == rhs
}

class CombineLatest3Tests: XCTestCase {
    let ints = PushStream<Int>()
    let strings = PushStream<String>()
    let bools = PushStream<Bool>()
    var combinedStream: Stream<(Int, String, Bool)>!
    var observation: Disposing!
    var observedCombinedValue: (Int, String, Bool)?

    override func setUp() {
        super.setUp()
        combinedStream = combineLatest(ints, strings, bools)
        observation = combinedStream.observeNext { (value: (Int, String, Bool)) in
            self.observedCombinedValue = value
        }
        XCTAssertNil(observedCombinedValue)
    }

    override func tearDown() {
        super.tearDown()
        observation.dispose()
    }

    func test_combineLatest() {
        ints.next(1)
        XCTAssertNil(observedCombinedValue)

        strings.next("a")
        XCTAssertNil(observedCombinedValue)

        bools.next(true)
        XCTAssertTrue(observedCombinedValue == (1, "a", true))

        strings.next("b")
        XCTAssertTrue(observedCombinedValue == (1, "b", true))

        ints.next(2)
        XCTAssertTrue(observedCombinedValue == (2, "b", true))

        bools.next(false)
        XCTAssertTrue(observedCombinedValue == (2, "b", false))
    }
}

public func ==<A: Equatable, B: Equatable>(lhs: (A?, B?), rhs: (A?, B?)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}
public func ==<A: Equatable, B: Equatable>(lhs: (A?, B?)?, rhs: (A?, B?)) -> Bool {
    guard let lhs = lhs else { return false }
    return lhs == rhs
}

class CombineLatestOptionalTests: XCTestCase {
    let ints = PushStream<Int?>()
    let strings = PushStream<String?>()
    var combinedStream: Stream<(Int?, String?)>!
    var observation: Disposing!
    var observedCombinedValue: (Int?, String?)?

    override func setUp() {
        super.setUp()
        combinedStream = combineLatest(ints, strings)
        observation = combinedStream.observeNext { (value: (Int?, String?)) in
            self.observedCombinedValue = value
        }
        XCTAssertNil(observedCombinedValue)
    }

    override func tearDown() {
        super.tearDown()
        observation.dispose()
    }

    func test_combineLatest_nil() {
        ints.next(nil)
        XCTAssertNil(observedCombinedValue)

        strings.next(nil)
        XCTAssertTrue(observedCombinedValue == (Int?, String?)(nil, nil))
    }

    func test_combineLatest_nilFirst() {
        ints.next(nil)
        XCTAssertNil(observedCombinedValue)

        strings.next("a")
        XCTAssertTrue(observedCombinedValue == (nil, "a"))

        strings.next("b")
        XCTAssertTrue(observedCombinedValue == (nil, "b"))

        ints.next(2)
        XCTAssertTrue(observedCombinedValue == (2, "b"))

        ints.next(nil)
        XCTAssertTrue(observedCombinedValue == (nil, "b"))

        strings.next(nil)
        XCTAssertTrue(observedCombinedValue == (nil, nil))
    }

    func test_combineLatest_nilSecond() {
        ints.next(1)
        XCTAssertNil(observedCombinedValue)

        strings.next(nil)
        XCTAssertTrue(observedCombinedValue == (1, nil))

        ints.next(2)
        XCTAssertTrue(observedCombinedValue == (2, nil))

        strings.next("b")
        XCTAssertTrue(observedCombinedValue == (2, "b"))

        strings.next(nil)
        XCTAssertTrue(observedCombinedValue == (2, nil))

        ints.next(nil)
        XCTAssertTrue(observedCombinedValue == (nil, nil))
    }

    func test_combineLatest_nonnil() {
        ints.next(1)
        XCTAssertNil(observedCombinedValue)

        strings.next("a")
        XCTAssertTrue(observedCombinedValue == (1, "a"))

        strings.next("b")
        XCTAssertTrue(observedCombinedValue == (1, "b"))

        ints.next(2)
        XCTAssertTrue(observedCombinedValue == (2, "b"))
    }
}
