//
//  CombineLatestOptionalSpec.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 26/01/2018.
//  Copyright © 2018 AlbumPrinter. All rights reserved.
//

import Quick
import Nimble
@testable import ReactivePlayground

fileprivate struct Tuple<A: Equatable, B: Equatable> {
    var value: (A?, B?)
}

extension Tuple: Equatable {}
fileprivate func ==<A, B>(lhs: Tuple<A, B>, rhs: Tuple<A, B>) -> Bool {
    return lhs.value == rhs.value
}
fileprivate func ==<A: Equatable, B: Equatable>(lhs: (A?, B?), rhs: (A?, B?)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}

class CombineLatestOptionalSpec: TestSpec {
    override func spec() {
        var ints: PushStream_DEPRECATED<Int?>!
        var strings: PushStream_DEPRECATED<String?>!
        var observedCombinedValue: Tuple<Int, String>?

        beforeEach {
            ints = PushStream_DEPRECATED()
            strings = PushStream_DEPRECATED()

            observedCombinedValue = nil
            combineLatest(ints, strings)
                .observeNext { (value: (Int?, String?)) in
                    observedCombinedValue = Tuple(value: value)
                }
                .disposed(afterEach: self)
        }

        it("initially nil") {
            expect(observedCombinedValue).to(beNil())
        }

        describe("both streams emit nil") {
            context("first stream emits nil") {
                beforeEach {
                    ints.next(nil)
                }
                it("combined value is still nil") {
                    expect(observedCombinedValue).to(beNil())
                }

                context("second stream emits nil") {
                    beforeEach {
                        strings.next(nil)
                    }
                    it("combined value is emitted") {
                        expect(observedCombinedValue) == Tuple(value: (nil, nil))
                    }
                }
            }
        } // describe("both streams emit nil")

        describe("first stream keeps emitting nil") {
            context("1 -> nil") {
                beforeEach {
                    ints.next(nil)
                }
                it("nil") {
                    expect(observedCombinedValue).to(beNil())
                }

                context("2 -> a") {
                    beforeEach {
                        strings.next("a")
                    }
                    it("(nil, a)") {
                        expect(observedCombinedValue) == Tuple(value: (nil, "a"))
                    }

                    context("2 -> b") {
                        beforeEach {
                            strings.next("b")
                        }
                        it("(nil, b)") {
                            expect(observedCombinedValue) == Tuple(value: (nil, "b"))
                        }

                        context("1 -> 2") {
                            beforeEach {
                                ints.next(2)
                            }
                            it("(2, b)") {
                                expect(observedCombinedValue) == Tuple(value: (2, "b"))
                            }

                            context("1 -> nil") {
                                beforeEach {
                                    ints.next(nil)
                                }
                                it("(nil, b)") {
                                    expect(observedCombinedValue) == Tuple(value: (nil, "b"))
                                }

                                context("2 -> nil") {
                                    beforeEach {
                                        strings.next(nil)
                                    }
                                    it("(nil, nil)") {
                                        expect(observedCombinedValue) == Tuple(value: (nil, nil))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } // describe("first stream keeps emitting nil")

        describe("second stream keeps emitting nil") {
            context("1 -> 1") {
                beforeEach {
                    ints.next(1)
                }
                it("nil") {
                    expect(observedCombinedValue).to(beNil())
                }

                context("2 -> nil") {
                    beforeEach {
                        strings.next(nil)
                    }
                    it("(1, nil)") {
                        expect(observedCombinedValue) == Tuple(value: (1, nil))
                    }

                    context("1 -> 2") {
                        beforeEach {
                            ints.next(2)
                        }
                        it("(2, nil)") {
                            expect(observedCombinedValue) == Tuple(value: (2, nil))
                        }

                        context("2 -> b") {
                            beforeEach {
                                strings.next("b")
                            }
                            it("(2, b)") {
                                expect(observedCombinedValue) == Tuple(value: (2, "b"))
                            }

                            context("2 -> nil") {
                                beforeEach {
                                    strings.next(nil)
                                }
                                it("(2, nil)") {
                                    expect(observedCombinedValue) == Tuple(value: (2, nil))
                                }

                                context("1 -> nil") {
                                    beforeEach {
                                        ints.next(nil)
                                    }
                                    it("(nil, nil)") {
                                        expect(observedCombinedValue) == Tuple(value: (nil, nil))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } // describe("second stream keeps emitting nil")

        describe("both streams emit non-nil") {
            context("1 -> 1") {
                beforeEach {
                    ints.next(1)
                }
                it("nil") {
                    expect(observedCombinedValue).to(beNil())
                }

                context("2 -> a") {
                    beforeEach {
                        strings.next("a")
                    }
                    it("(1, a)") {
                        expect(observedCombinedValue) == Tuple(value: (1, "a"))
                    }

                    context("2 -> b") {
                        beforeEach {
                            strings.next("b")
                        }
                        it("(1, b)") {
                            expect(observedCombinedValue) == Tuple(value: (1, "b"))
                        }

                        context("1 -> 2") {
                            beforeEach {
                                ints.next(2)
                            }
                            it("(2, b)") {
                                expect(observedCombinedValue) == Tuple(value: (2, "b"))
                            }
                        }
                    }
                }
            }
        } // describe("both streams emit non-nil")
    }
}

