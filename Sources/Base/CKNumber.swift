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
infix operator ~=*

public func ~=+<T: Integer>(lhs: T, rhs: (T, T)) -> Bool {
    let r = rhs.0
    let f = rhs.1
    return lhs > r - f && lhs < r + f
}

public func ~=+<T: FloatingPoint>(lhs: T, rhs: (T, T)) -> Bool {
    let r = rhs.0
    let f = rhs.1
    return lhs > r - f && lhs < r + f
}

public func ~=*<T: Integer>(lhs: T, rhs: (T, T)) -> Bool {
    let r = rhs.0
    let p = rhs.1
    return lhs > r - r * p && lhs < r + r * p
}

public func ~=*<T: FloatingPoint>(lhs: T, rhs: (T, T)) -> Bool {
    let r = rhs.0
    let p = rhs.1
    return lhs > r - r * p && lhs < r + r * p
}

public extension Int {
    init(fromBool bool: Bool) {
        self.init()
        
        if bool {
            self = 1
        } else {
            self = 0
        }
    }
    
    static func random(_ a: Int = 0, _ b: Int) -> Int {
        var a = a
        var b = b
        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
    
    mutating func sqr() -> Int {
        self = self * self
        return self * self
    }
    
    var string: String {
        return "\(self)"
    }
    
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
    
    var double: Double {
        return Double(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var float: Float {
        return Float(self)
    }
    
    mutating func limitIn(_ begin: Int, _ end: Int) {
        if self < begin {
            self = begin
        }
        if self > end {
            self = end
        }
    }
}

//Random float point numbder
public extension ClosedRange where Bound: FloatingPoint {
    func random() -> Bound {
        let range = self.upperBound - self.lowerBound
        let randomValue = (Bound(arc4random_uniform(UINT32_MAX)) / Bound(UINT32_MAX)) * range + self.lowerBound
        return randomValue
    }
}

public extension Double {
    var radius: Double {
        return self * (.pi / 180)
    }
    
    var string: String {
        return "\(self)"
    }
    
    func string(digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
    
    var int: Int {
        return Int(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var float: Float {
        return Float(self)
    }
    
    mutating func limitIn(_ begin: Double, _ end: Double) {
        if self < begin {
            self = begin
        }
        if self > end {
            self = end
        }
    }
}

public extension Float {
    var radius: Float {
        return self * Float(Double.pi / 180)
    }
    
    mutating func sqr() -> Float? {
        self = self * self
        return self
    }
    
    var string: String {
        return "\(self)"
    }
    
    func string(digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
    
    var int: Int {
        return Int(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
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
    var radius: CGFloat {
        return self * CGFloat(Double.pi / 180)
    }
    
    mutating func sqr() -> CGFloat {
        self = self * self
        return self * self
    }
    
    var string: String {
        return "\(self)"
    }
    
    func string(digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
    
    var int: Int {
        return Int(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var float: Float {
        return Float(self)
    }
    
    mutating func limitIn(_ begin: CGFloat, _ end: CGFloat) {
        if self < begin {
            self = begin
        }
        if self > end {
            self = end
        }
    }
}
