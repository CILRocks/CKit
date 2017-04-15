import Foundation
#if os(iOS)
    import UIKit
#endif

#if os(OSX)
    import AppKit
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
    public extension UIDevice {
        static var isPhone: Bool {
            return current.userInterfaceIdiom == .phone
        }
    }
#endif

#if os(OSX)
    
#endif

public extension NSLocale {
    static var isChina: Bool {
        return NSLocale.current.regionCode == "CN"
    }
    
    static var languageRegionCode: String {
        return "\(self.current.languageCode!)-\(self.current.regionCode!)"
    }
}

public extension String {
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start..<end]
    }
    
    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start...end]
    }
    
    //To numbers
    var int: Int {
        return Int(self)!
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self.float)
    }
    
    var float: Float {
        return Float(self)!
    }
    
    var double: Double {
        return Double(self)!
    }
    
    var nsString: NSString {
        return NSString(string: self)
    }
    
    static func random(_ length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    mutating func escape() {
        var new = self.replacingOccurrences(of: "\"", with: "\"\"")
        if new.contains(",") || new.contains("\n") {
            new = String(format: "\"%@\"", new)
        }
        self = new
    }
    
    var encodedURI: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    var escaped: String {
        var new = self.replacingOccurrences(of: "\"", with: "\"\"")
        if new.contains(",") || new.contains("\n") {
            new = String(format: "\"%@\"", new)
        }
        return new
    }
    
    mutating func format(using format: String) {
        self = String(format: format, self)
    }
    
    func formatted(using format: String) -> String {
        return String(format: format, self)
    }
    
    mutating func prefix(_ aString: String) {
        self = "\(aString)\(self)"
    }
}

public extension Bool {
    init(fromInt int: Int) {
        self.init()
        
        if int == 0 {
            self = false
        } else {
            self = true
        }
    }
    
    func toInt() -> Int {
        if self {
            return 1
        } else {
            return 0
        }
    }
    
    var string: String {
        return "\(self)"
    }
    
    mutating func reverse() {
        self = !self
    }
}

public extension Array {
    var shuffled: [Any] {
        var result = self
        for _ in 0...32 {
            let a = Int.random(0, result.count - 1)
            var b = 0
            repeat {
                b = Int.random(0, result.count - 1)
            } while a == b
            let t = result[b]
            result[b] = result[a]
            result[a] = t
        }
        return result
    }
    
    var cgPoint: CGPoint {
        if count > 1 {
            if Element.self is CGFloat.Type {
                return CGPoint(x: self[0] as! CGFloat, y: self[1] as! CGFloat)
            } else if Element.self is Double.Type {
                return CGPoint(x: self[0] as! Double, y: self[1] as! Double)
            } else if Element.self is Int.Type {
                return CGPoint(x: self[0] as! Int, y: self[1] as! Int)
            } else {
                return CGPoint.zero
            }
        } else {
            return CGPoint.zero
        }
    }
}

public extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        let flag = "FirstLaunchFlag"
        
        if !UserDefaults.standard.bool(forKey: flag) {
            UserDefaults.standard.set(true, forKey: flag)
            return true
        }
        return false
    }
}

public func sqr(x: CGFloat) -> CGFloat {
    return x * x
}

public func sqr(x: Float) -> Float {
    return x * x
}

public extension LazyMapRandomAccessCollection {
    var array: [Any] {
        return Array(self)
    }
}
