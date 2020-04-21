//
//  Operations.swift
//  ReactivePlayground
//
//  Created by Ivan Misuno on 22/11/2017.
//


/// Combine the value emitted by one of the observables with the latest value emitted by the other observable, and produce the stream emitting the resulting value.
/// Ref: http://reactivex.io/documentation/operators/combinelatest.html
func combineLatest<A, B>(_ a: Stream_DEPRECATED<A>, _ b: Stream_DEPRECATED<B>) -> Stream_DEPRECATED<(A, B)> {
    return ProducingStream_DEPRECATED { (observer: @escaping ((A, B)) -> ()) -> Disposing_DEPRECATED in
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
        return Disposable_DEPRECATED { _ in
            observationA.dispose()
            observationB.dispose()
        }
    }
}

func combineLatest<A, B, C>(_ a: Stream_DEPRECATED<A>, _ b: Stream_DEPRECATED<B>, _ c: Stream_DEPRECATED<C>) -> Stream_DEPRECATED<(A, B, C)> {
    return combineLatest(combineLatest(a, b), c)
        .map { (value: (ab: (a: A, b: B), c: C)) -> (A, B, C) in
            return (value.ab.a, value.ab.b, value.c)
        }
}

extension Observable_DEPRECATED {
    /// Convert the value emitted by self with the given transform function, and produce the stream emitting the transformed value.
    func map<U>(_ transform: @escaping (EventType) -> U) -> Stream_DEPRECATED<U> {
        return ProducingStream_DEPRECATED { (observer: @escaping (U) -> ()) -> Disposing_DEPRECATED in
            let disposable = self.observeNext { (event: EventType) in
                observer(transform(event))
            }
            return disposable
        }
    }
}
