//
//  Result.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

import Cocoa

public class Box<A> {
    let value : A
    public init(_ value : A) {
        self.value = value
    }
}

public enum Result<A> {
    case Success(Box<A>)
    case Failure(String)
    
    public func bind<T>(f : A -> Result<T>) -> Result<T> {
        switch self {
        case Success(let v): return f(v.value)
        case Failure(let s): return .Failure(s)
        }
    }
    
    public func ifSuccess(f : A -> Void) -> Result<A> {
        switch self {
        case Success(let v): f(v.value)
        case Failure(_): break
        }
        return self
    }
    
    public func ifFailure(f : String -> Void) -> Result<A> {
        switch self {
        case Success(_): break
        case Failure(let message): f(message)
        }
        return self
    }
    
    public var value : A? {
        switch self {
        case Success(let v): return v.value
        case Failure(_): return nil
        }
    }
    
    public var error : String? {
        switch self {
        case Success(_): return nil
        case let Failure(e): return e
        }
    }
}

public func Success<A>(v : A) -> Result<A> {
    return Result.Success(Box(v))
}

public func Failure<A>(s : String) -> Result<A> {
    return Result.Failure(s)
}