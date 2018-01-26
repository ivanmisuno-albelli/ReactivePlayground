//
//  VariableTests.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 17/11/2017.
//

import XCTest
@testable import ReactivePlayground

class VariableTests: XCTestCase {

    let variable = Variable<String>("a")

    func test_subscription_updatesWithCurrentValue() {
        var observedString1: String? = nil
        let subscription1 = variable.observeNext { value in
            observedString1 = value
        }
        defer { subscription1.dispose() }

        XCTAssertEqual(observedString1, "a")
    }

    func test_settingValue_updatesSubscriber() {
        var observedString1: String? = nil
        let subscription1 = variable.observeNext { value in
            observedString1 = value
        }
        defer { subscription1.dispose() }

        variable.value = "b"
        XCTAssertEqual(observedString1, "b")
    }
}
