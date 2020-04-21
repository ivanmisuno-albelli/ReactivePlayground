//
//  Subject_DEPRECATED.swift
//  ReactivePlayground
//
//  Created by Ivan Misuno on 22/11/2017.
//

protocol Subject_DEPRECATED {
    associatedtype EventType
    typealias Observer = (EventType) -> ()
    func observer() -> Observer
}

extension PushStream_DEPRECATED: Subject_DEPRECATED {
    func observer() -> Observer {
        return next
    }
}

extension Variable_DEPRECATED: Subject_DEPRECATED {
    func observer() -> Observer {
        return { event in
            self.value = event            
        }
    }
}

extension Observable_DEPRECATED {
    func bindTo<U: Subject_DEPRECATED>(_ subject: U) -> Disposing_DEPRECATED where U.EventType == EventType {
        return observeNext(subject.observer())
    }
}
