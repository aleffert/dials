//
//  Result.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

import Cocoa

open class Box<A> {
    let value : A
    public init(_ value : A) {
        self.value = value
    }
}

public enum Result<A> {
    case success(Box<A>)
    case failure(String)
    
    public func bind<T>(_ f : (A) -> Result<T>) -> Result<T> {
        switch self {
        case .success(let v): return f(v.value)
        case .failure(let s): return .failure(s)
        }
    }
    
    public func ifSuccess(_ f : (A) -> Void) -> Result<A> {
        switch self {
        case .success(let v): f(v.value)
        case .failure(_): break
        }
        return self
    }
    
    public func ifFailure(_ f : (String) -> Void) -> Result<A> {
        switch self {
        case .success(_): break
        case .failure(let message): f(message)
        }
        return self
    }
    
    public var value : A? {
        switch self {
        case .success(let v): return v.value
        case .failure(_): return nil
        }
    }
    
    public var error : String? {
        switch self {
        case .success(_): return nil
        case let .failure(e): return e
        }
    }
}

public func Success<A>(_ v : A) -> Result<A> {
    return Result.success(Box(v))
}

public func Failure<A>(_ s : String) -> Result<A> {
    return Result.failure(s)
}
