//
//  TestSpec.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 06/12/2017.
//

import Quick

/// Base class for all tests; don't use QuickSpec directly.
/// The main purpose of this class is to override at the run-time configured
/// timers/schedulers/etc. to make testing of asynchronous code easier.
/// It will also contain helper methods (e.g., to record analytics events), etc.
class TestSpec: QuickSpec {
}
