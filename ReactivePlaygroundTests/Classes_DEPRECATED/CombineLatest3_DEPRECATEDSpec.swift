//
//  CombineLatest3Spec.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 26/01/2018.
//  Copyright © 2018 AlbumPrinter. All rights reserved.
//

import Quick
import Nimble
@testable import ReactivePlayground

fileprivate struct Tuple<A: Equatable, B: Equatable, C: Equatable> {
    var value: (A, B, C)
}

extension Tuple: Equatable {}
fileprivate func ==<A, B, C>(lhs: Tuple<A, B, C>, rhs: Tuple<A, B, C>) -> Bool {
    return lhs.value == rhs.value
}

class CombineLatest3Spec: TestSpec {
    override func spec() {
        describe("combineLatest()") {
            var ints: PushStream_DEPRECATED<Int>!
            var strings: PushStream_DEPRECATED<String>!
            var bools: PushStream_DEPRECATED<Bool>!
            var observedCombinedValue: Tuple<Int, String, Bool>?

            beforeEach {
                ints = PushStream_DEPRECATED()
                strings = PushStream_DEPRECATED()
                bools = PushStream_DEPRECATED()

                observedCombinedValue = nil
                combineLatest(ints, strings, bools)
                    .observeNext { (value: (Int, String, Bool)) in
                        observedCombinedValue = Tuple(value: value)
                    }
                    .disposed(afterEach: self)
            }

            it("initially nil") {
                expect(observedCombinedValue).to(beNil())
            }

            context("ints emits value") {
                beforeEach {
                    ints.next(1)
                }
                it("value is not emitted yet") {
                    expect(observedCombinedValue).to(beNil())
                }

                context("strings emits value") {
                    beforeEach {
                        strings.next("a")
                    }
                    it("value is not emitted yet") {
                        expect(observedCombinedValue).to(beNil())
                    }

                    context("bools emits value") {
                        beforeEach {
                            bools.next(true)
                        }
                        it("value is emitted") {
                            expect(observedCombinedValue) == Tuple(value: (1, "a", true))
                        }

                        context("strings emits again") {
                            beforeEach {
                                strings.next("b")
                            }
                            it("value is emitted") {
                                expect(observedCombinedValue) == Tuple(value: (1, "b", true))
                            }

                            context("ints emits again") {
                                beforeEach {
                                    ints.next(2)
                                }
                                it("value is emitted") {
                                    expect(observedCombinedValue) == Tuple(value: (2, "b", true))
                                }

                                context("bools emits egain") {
                                    beforeEach {
                                        bools.next(false)
                                    }
                                    it("value is emitted") {
                                        expect(observedCombinedValue) == Tuple(value: (2, "b", false))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
