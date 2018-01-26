//
//  Subject.swift
//  ReactivePlayground
//
//  Created by Ivan Misuno on 22/11/2017.
//

protocol Subject {
    associatedtype EventType
    typealias Observer = (EventType) -> ()
    func observer() -> Observer
}

extension PushStream: Subject {
    func observer() -> Observer {
        return next
    }
}

extension Variable: Subject {
    func observer() -> Observer {
        return { event in
            self.value = event            
        }
    }
}

extension Observable {
    func bindTo<U: Subject>(_ subject: U) -> Disposing where U.EventType == EventType {
        return observeNext(subject.observer())
    }
}
