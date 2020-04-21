//
//  CombineLatestTests.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 22/11/2017.
//

import Quick
import Nimble
@testable import ReactivePlayground

fileprivate struct Tuple<A: Equatable, B: Equatable> {
    var value: (A, B)
}

extension Tuple: Equatable {}
fileprivate func ==<A, B>(lhs: Tuple<A, B>, rhs: Tuple<A, B>) -> Bool {
    return lhs.value == rhs.value
}

class CombineLatestSpec: TestSpec {
    override func spec() {
        describe("combineLatest()") {
            var ints: PushStream_DEPRECATED<Int>!
            var strings: PushStream_DEPRECATED<String>!
            var observedCombinedValue: Tuple<Int, String>?

            beforeEach {
                ints = PushStream_DEPRECATED()
                strings = PushStream_DEPRECATED()

                observedCombinedValue = nil
                combineLatest(ints, strings)
                    .observeNext { (value: (Int, String)) in
                        observedCombinedValue = Tuple(value: value)
                    }
                    .disposed(afterEach: self)
            }

            it("initially nil") {
                expect(observedCombinedValue).to(beNil())
            }

            context("int is emitted") {
                beforeEach {
                    ints.next(1)
                }
                it("still no combined value emitted") {
                    expect(observedCombinedValue).to(beNil())
                }

                context("string is emitted") {
                    beforeEach {
                        strings.next("a")
                    }
                    it("combined value is emitted") {
                        expect(observedCombinedValue) == Tuple(value: (1, "a"))
                    }

                    context("next string is emitted") {
                        beforeEach {
                            strings.next("b")
                        }
                        it("new combined value is emitted") {
                            expect(observedCombinedValue) == Tuple(value: (1, "b"))
                        }

                        context("next int is emitted") {
                            beforeEach {
                                ints.next(2)
                            }
                            it("new combined value is emitted") {
                                expect(observedCombinedValue) == Tuple(value: (2, "b"))
                            }
                        }
                    }
                }
            }
        }
    }
}
