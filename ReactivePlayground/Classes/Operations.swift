//
//  Operations.swift
//  ReactivePlayground
//
//  Created by Ivan Misuno on 22/11/2017.
//


/// Combine the value emitted by one of the observables with the latest value emitted by the other observable, and produce the stream emitting the resulting value.
/// Ref: http://reactivex.io/documentation/operators/combinelatest.html
func combineLatest<A, B>(_ a: Stream<A>, _ b: Stream<B>) -> Stream<(A, B)> {
    return ProducingStream { (observer: @escaping ((A, B)) -> ()) -> Disposing in
        var observedA: A?
        var observedB: B?
        let updateObserverIfBothValuesAvailable = { () -> () in
            guard let observedA = observedA, let observedB = observedB else { return }
            observer((observedA, observedB))
        }
        let observationA = a.observeNext { (a: A) in
            observedA = a
            updateObserverIfBothValuesAvailable()
        }
        let observationB = b.observeNext { (b: B) in
            observedB = b
            updateObserverIfBothValuesAvailable()
        }
        return Disposable { _ in
            observationA.dispose()
            observationB.dispose()
        }
    }
}

func combineLatest<A, B, C>(_ a: Stream<A>, _ b: Stream<B>, _ c: Stream<C>) -> Stream<(A, B, C)> {
    return combineLatest(combineLatest(a, b), c)
        .map { (value: (ab: (a: A, b: B), c: C)) -> (A, B, C) in
            return (value.ab.a, value.ab.b, value.c)
        }
}

extension Observable {
    /// Convert the value emitted by self with the given transform function, and produce the stream emitting the transformed value.
    func map<U>(_ transform: @escaping (EventType) -> U) -> Stream<U> {
        return ProducingStream { (observer: @escaping (U) -> ()) -> Disposing in
            let disposable = self.observeNext { (event: EventType) in
                observer(transform(event))
            }
            return disposable
        }
    }
}
