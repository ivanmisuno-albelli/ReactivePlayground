//
//  DisposableTests.swift
//  ReactivePlayground-ios-tests
//
//  Created by Ivan Misuno on 17/11/2017.
//

import Quick
import Nimble
@testable import ReactivePlayground

class DisposableSpec: TestSpec {
    override func spec() {
        describe("Disposable") {

            describe("normal operation") {
                var disposable: Disposable!
                var disposeClosureInvoked: Bool = false
                var disposeClosureInvocationCount: Int = 0
                beforeEach {
                    disposeClosureInvoked = false
                    disposeClosureInvocationCount = 0
                    disposable = Disposable { _ in
                        disposeClosureInvoked = true
                        disposeClosureInvocationCount += 1
                    }
                }
                afterEach {
                    // must explicitly cleanup
                    if !disposable.isDisposed {
                        disposable.dispose()
                    }
                }

                it("initially not disposed") {
                    expect(disposable.isDisposed) == false
                }

                context("calling dispose()") {
                    beforeEach {
                        disposable.dispose()
                    }
                    it("makes it disposed") {
                        expect(disposable.isDisposed) == true
                    }
                    it("invokes dispose closure") {
                        expect(disposeClosureInvoked) == true
                    }

                    context("calling dispose() multiple times") {
                        beforeEach {
                            disposable.dispose()
                        }
                        it("invokes dispose closure only once") {
                            expect(disposeClosureInvocationCount) == 1
                        }
                    }
                }

                describe("scoped disposable") {
                    describe("normal behaviour") {
                        var scopedDisposable: Disposing!
                        beforeEach {
                            scopedDisposable = disposable.asScopedDisposable
                        }

                        it("initially not disposed") {
                            expect(scopedDisposable.isDisposed) == false
                            expect(disposable.isDisposed) == false
                        }

                        context("calling dispose() on the source disposable") {
                            beforeEach {
                                disposable.dispose()
                            }
                            it("makes scoped disposable disposed as well") {
                                expect(scopedDisposable.isDisposed) == true
                                expect(disposable.isDisposed) == true
                            }
                        }

                        context("calling dispose() on the scoped disposable") {
                            beforeEach {
                                scopedDisposable.dispose()
                            }
                            it("makes source disposable disposed as well") {
                                expect(scopedDisposable.isDisposed) == true
                                expect(disposable.isDisposed) == true
                            }
                        }
                    }

                    describe("deallocation behaviour") {
                        var disposeClosureInvoked = false
                        beforeEach {
                            autoreleasepool {
                                _ = Disposable({_ in disposeClosureInvoked = true }).asScopedDisposable
                            }
                        }
                        it("on deallocation disposes") {
                            expect(disposeClosureInvoked) == true
                        }
                    }
                }
            }

            describe("deallocation behaviour") {
                it("deallocating when not disposed asserts") {
                    expect {
                        autoreleasepool { () -> Void in
                            _ = Disposable { _ in }
                        }
                    }.to(throwAssertion()) // https://github.com/Quick/Nimble#swift-assertions
                }
            }
        }
    }
}
