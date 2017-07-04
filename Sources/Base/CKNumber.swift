//
//  CKNumber.swift
//  CKit
//
//  Created by CHU on 2017/4/8.
//
//

import Foundation
#if os(iOS)
    import UIKit
#endif

#if os(OSX)
    import AppKit
#endif

infix operator ~=+
/**
 Check if the `int` is in the range of `rhs.0±rhs.1`
 
 - parameter lhs: The number to test.
 - parameter rhs: Will check if `lhs` falls between `rhs.0-rhs.1` and `rhs.0+rhs.1`
 */
public func ~=+<T: Integer>(lhs: T, rhs: (T, T)) -> Bool {
    let r = rhs.0
    let f = rhs.1
    return lhs > r - f && lhs < r + f
}

/**
 Check if the `floating point` number is in the range of `rhs.0±rhs.1`
 
 - parameter lhs: The number to test.
 - parameter rhs: Will check if `lhs` falls between `rhs.0-rhs.1` and `rhs.0+rhs.1`
 */
public func ~=+<T: FloatingPoint>(lhs: T, rhs: (T, T)) -> Bool {
    let r = rhs.0
    let f = rhs.1
    return lhs > r - f && lhs < r + f
}

infix operator ~=*
/**
 Check if the `int` is in the range of `rhs.0±rhs.0*rhs.1`
 
 - parameter lhs: The number to test.
 - parameter rhs: Will check if `lhs` falls between `rhs.0-rhs.0*rhs.1` and `rhs.0+rhs.0*rhs.1`
 */
public func ~=*<T: Integer>(lhs: T, rhs: (T, T)) -> Bool {
    let r = rhs.0
    let p = rhs.1
    return lhs > r - r * p && lhs < r + r * p
}

/**
 Check if the `floating point` number is in the range of `rhs.0±rhs.0*rhs.1`
 
 - parameter lhs: The number to test.
 - parameter rhs: Will check if `lhs` falls between `rhs.0-rhs.0*rhs.1` and `rhs.0+rhs.0*rhs.1`
 */
public func ~=*<T: FloatingPoint>(lhs: T, rhs: (T, T)) -> Bool {
    let r = rhs.0
    let p = rhs.1
    return lhs > r - r * p && lhs < r + r * p
}

public extension Int {
    /**
     Create an `int` from `bool`.
     
     - parameter bool: A `bool` value.
     */
    init(fromBool bool: Bool) {
        self.init()
        
        self = bool ? 1 : 0
    }
    
    /**
     Create a random `int` within given range.
     
     - parameter a: Minimal limit. `default` is `0`
     - parameter b: Maximal limit.
     */
    static func random(_ a: Int = 0, _ b: Int) -> Int {
        var a = a
        var b = b
        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
    
    /**
     Square root the `int`.
     */
    mutating func sqr() -> Int {
        self = self * self
        return self * self
    }
    
    /**
     The `string` representation of the `int`.
     */
    var string: String {
        return "\(self)"
    }
    
    /**
     The `string` representation of the `int` with a given digit length.
     
     - parameter digits: How many digits you want the result `string` have.
     */
    func string(digits: Int) -> String {
        var s = self.string
        if s.characters.count < digits {
            let left = digits - s.characters.count
            for _ in 1...left {
                s = "0\(s)"
            }
        }
        return s
    }
    
    /**
     The `double` representation of the `int`.
     */
    var double: Double {
        return Double(self)
    }
    
    /**
     The Core Graphic `float` representation of the `int`.
     */
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    /**
     The `float` representation of the `int`.
     */
    var float: Float {
        return Float(self)
    }
    
    /**
     Clamp the `int` to given range.
     
     - parameter begin: Minimal limit.
     - parameter end: Maximal limit.
     */
    mutating func limitIn(_ begin: Int, _ end: Int) {
        if self < begin {
            self = begin
        }
        if self > end {
            self = end
        }
    }
}

public extension ClosedRange where Bound: FloatingPoint {
    /**
     Create a random `float point` number.
     */
    func random() -> Bound {
        let range = self.upperBound - self.lowerBound
        let randomValue = (Bound(arc4random_uniform(UINT32_MAX)) / Bound(UINT32_MAX)) * range + self.lowerBound
        return randomValue
    }
}

public extension Double {
    /**
     The radius representation of the `double`.
     */
    var radius: Double {
        return self * (.pi / 180)
    }
    
    /**
     The `string` representation of the `double`.
     */
    var string: String {
        return "\(self)"
    }
    
    /**
     The `string` representation of the `double` with a given digit length.
     
     - parameter digits: How many digits you want the result `string` have.
     */
    func string(digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
    
    /**
     The `int` representation of the `double`.
     */
    var int: Int {
        return Int(self)
    }
    
    /**
     The Core Graphic `float` representation of the `double`.
     */
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    /**
     The `float` representation of the `double`.
     */
    var float: Float {
        return Float(self)
    }
    
    /**
     Clamp the `double` to given range.
     
     - parameter begin: Minimal limit.
     - parameter end: Maximal limit.
     */
    mutating func limitIn(_ begin: Double, _ end: Double) {
        if self < begin {
            self = begin
        }
        if self > end {
            self = end
        }
    }
}

public extension TimeInterval {
    /**
     The `TimeInterval` representation of given minutes
     */
    var ckMinutes: TimeInterval {
        return self * 60
    }
    
    /**
     The `TimeInterval` representation of given hours
     */
    var ckHours: TimeInterval {
        return self * 3600
    }
    
    /**
     The `TimeInterval` representation of given days
     */
    var ckDays: TimeInterval {
        return self * 86400
    }
}

public extension Float {
    /**
     The radius representation of the `float`.
     */
    var radius: Float {
        return self * Float(Double.pi / 180)
    }
    
    /**
     Square root the `float`.
     */
    mutating func sqr() -> Float? {
        self = self * self
        return self
    }
    
    /**
     The `string` representation of the `float`.
     */
    var string: String {
        return "\(self)"
    }
    
    /**
     The `string` representation of the `float` with a given digit length.
     
     - parameter digits: How many digits you want the result `string` have.
     */
    func string(digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
    
    /**
     The `string` representation of the `float`.
     */
    var int: Int {
        return Int(self)
    }
    
    /**
     The `int` representation of the `float`.
     */
    var double: Double {
        return Double(self)
    }
    
    /**
     The Core Graphic `float` representation of the `float`.
     */
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    /**
     Clamp the `float` to given range.
     
     - parameter begin: Minimal limit.
     - parameter end: Maximal limit.
     */
    mutating func limitIn(_ begin: Float, _ end: Float) {
        if self < begin {
            self = begin
        }
        if self > end {
            self = end
        }
    }
}

public extension CGFloat {
    /**
     The radius representation of the Core Graphic `float`.
     */
    var radius: CGFloat {
        return self * CGFloat(Double.pi / 180)
    }
    
    /**
     Square root the Core Graphic `float`.
     */
    mutating func sqr() -> CGFloat {
        self = self * self
        return self * self
    }
    
    /**
     The `string` representation of the Core Graphic `float`.
     */
    var string: String {
        return "\(self)"
    }
    
    /**
     The `string` representation of the Core Graphic `float` with a given digit length.
     
     - parameter digits: How many digits you want the result `string` have.
     */
    func string(digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
    
    /**
     The `int` representation of the Core Graphic `float`.
     */
    var int: Int {
        return Int(self)
    }
    
    /**
     The `double` representation of the Core Graphic `float`.
     */
    var double: Double {
        return Double(self)
    }
    
    /**
     The `float` representation of the Core Graphic `float`.
     */
    var float: Float {
        return Float(self)
    }
    
    /**
     Clamp the Core Graphic `float` to given range.
     
     - parameter begin: Minimal limit.
     - parameter end: Maximal limit.
     */
    mutating func limitIn(_ begin: CGFloat, _ end: CGFloat) {
        if self < begin {
            self = begin
        }
        if self > end {
            self = end
        }
    }
}
