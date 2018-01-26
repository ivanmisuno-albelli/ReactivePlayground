//
//  Stream.swift
//  ReactivePlayground
//
//  Created by Ivan Misuno on 16/11/2017.
//

/// Base Stream class implements generic observing behaviour.
class Stream<EventType>: Observable {
    private let producer: (_ observer: @escaping (EventType) -> ()) -> Disposing

    fileprivate init(producer: @escaping (_ observer: @escaping (EventType) -> ()) -> Disposing) {
        self.producer = producer
    }

    // MARK: - Observable
    func observeNext(_ observer: @escaping (EventType) -> ()) -> Disposing {
        return producer(observer)
    }
}

/// ProducingStream can be constructed with the `producer` closure which will be invoked upon subscription.
/// Suitable in situations when new operation needs to be started for each new subscriber, e.g., network request.
final class ProducingStream<EventType>: Stream<EventType> {
    override init(producer: @escaping (_ observer: @escaping (EventType) -> ()) -> Disposing) {
        super.init(producer: producer)
    }
}

/// PushStream allows sending `next` events to its subscribers.
final class PushStream<EventType>: Stream<EventType> {
    private let observers: ObserverList<EventType>

    init() {
        let observers = ObserverList<EventType>()
        self.observers = observers
        super.init { (observer: @escaping (EventType) -> ()) -> Disposing in
            return observers.add(observer: observer)
        }
    }

    final func next(_ event: EventType) {
        observers.forEach { (observer) in
            observer(event)
        }
    }
}

/// Variable has current value.
/// Observers are updated when current value changes.
/// Upon subscription, current value is immediately sent to the observer.
final class Variable<EventType>: Stream<EventType> {

    private let observers: ObserverList<EventType>

    var value: EventType {
        didSet {
            update(value)
        }
    }

    init(_ value: EventType) {
        self.value = value
        let observers = ObserverList<EventType>()
        self.observers = observers
        super.init { (observer: @escaping (EventType) -> ()) -> Disposing in
            return observers.add(observer: observer)
        }
    }

    // MARK: - Observable
    override func observeNext(_ observer: @escaping (EventType) -> ()) -> Disposing {
        defer {
            observer(value)
        }
        return super.observeNext(observer)
    }

    // MARK: - Private
    private func update(_ event: EventType) {
        observers.forEach { (observer) in
            observer(event)
        }
    }
}
