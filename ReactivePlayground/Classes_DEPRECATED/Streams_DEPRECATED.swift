//
//  Stream_DEPRECATED.swift
//  ReactivePlayground
//
//  Created by Ivan Misuno on 16/11/2017.
//

/// Base Stream_DEPRECATED class implements generic observing behaviour.
class Stream_DEPRECATED<EventType>: Observable_DEPRECATED {
    private let producer: (_ observer: @escaping (EventType) -> ()) -> Disposing_DEPRECATED

    fileprivate init(producer: @escaping (_ observer: @escaping (EventType) -> ()) -> Disposing_DEPRECATED) {
        self.producer = producer
    }

    // MARK: - Observable_DEPRECATED
    func observeNext(_ observer: @escaping (EventType) -> ()) -> Disposing_DEPRECATED {
        return producer(observer)
    }
}

/// ProducingStream_DEPRECATED can be constructed with the `producer` closure which will be invoked upon subscription.
/// Suitable in situations when new operation needs to be started for each new subscriber, e.g., network request.
final class ProducingStream_DEPRECATED<EventType>: Stream_DEPRECATED<EventType> {
    override init(producer: @escaping (_ observer: @escaping (EventType) -> ()) -> Disposing_DEPRECATED) {
        super.init(producer: producer)
    }
}

/// PushStream_DEPRECATED allows sending `next` events to its subscribers.
final class PushStream_DEPRECATED<EventType>: Stream_DEPRECATED<EventType> {
    private let observers: ObserverList_DEPRECATED<EventType>

    init() {
        let observers = ObserverList_DEPRECATED<EventType>()
        self.observers = observers
        super.init { (observer: @escaping (EventType) -> ()) -> Disposing_DEPRECATED in
            return observers.add(observer: observer)
        }
    }

    final func next(_ event: EventType) {
        observers.forEach { (observer) in
            observer(event)
        }
    }
}

/// Variable_DEPRECATED has current value.
/// Observers are updated when current value changes.
/// Upon subscription, current value is immediately sent to the observer.
final class Variable_DEPRECATED<EventType>: Stream_DEPRECATED<EventType> {

    private let observers: ObserverList_DEPRECATED<EventType>

    var value: EventType {
        didSet {
            update(value)
        }
    }

    init(_ value: EventType) {
        self.value = value
        let observers = ObserverList_DEPRECATED<EventType>()
        self.observers = observers
        super.init { (observer: @escaping (EventType) -> ()) -> Disposing_DEPRECATED in
            return observers.add(observer: observer)
        }
    }

    // MARK: - Observable_DEPRECATED
    override func observeNext(_ observer: @escaping (EventType) -> ()) -> Disposing_DEPRECATED {
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
