//
//  MulticastDelegate.swift
//  Assignment 2
//
//  Created by Chak Lee on 18/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import Foundation

class MulticastDelegate <T> {
    private var delegates = Set<WeakObjectWrapper>()
    
    func addDelegate(_ delegate: T) {
        let delegateObject = delegate as AnyObject
        delegates.insert(WeakObjectWrapper(value: delegateObject))
    }
    
    func removeDelegate(_ delegate: T) {
        let delegateObject = delegate as AnyObject
        delegates.remove(WeakObjectWrapper(value: delegateObject))
    }
    
    func invoke(invocation: (T) -> ()) {
        delegates.forEach { (delegateWrapper) in
            if let delegate = delegateWrapper.value {
                invocation(delegate as! T)
            }
        }
    }
}

private class WeakObjectWrapper: Equatable, Hashable {
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
    
    var hashValue: Int {
        return ObjectIdentifier(value!).hashValue
    }
    
    static func == (lhs: WeakObjectWrapper, rhs: WeakObjectWrapper) -> Bool {
        return lhs.value === rhs.value
    }
}
