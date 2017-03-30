import Foundation
#if os(iOS)
    import UIKit
#endif

#if os(OSX)
    import AppKit
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
    public extension UIColor {
        convenience init(hex: String) {
            let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt32()
            Scanner(string: hex).scanHexInt32(&int)
            let a, r, g, b: UInt32
            switch hex.characters.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
    }
    
    public extension UIDevice {
        static var isPhone: Bool {
            return current.userInterfaceIdiom == .phone
        }
    }
#endif

#if os(OSX)
    public extension NSColor {
        convenience init(hex: String) {
            let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt32()
            Scanner(string: hex).scanHexInt32(&int)
            let a, r, g, b: UInt32
            switch hex.characters.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
    }
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

public extension Int {
    init(fromBool bool: Bool) {
        self.init()
        
        if bool {
            self = 1
        } else {
            self = 0
        }
    }
    
    static func random(_ a: Int, _ b: Int) -> Int {
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
    var string: String {
        return "\(self)"
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
    mutating func sqr() -> Float? {
        self = self * self
        return self
    }
    
    var string: String {
        return "\(self)"
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
        return self * CGFloat(M_PI / 180)
    }
    
    mutating func sqr() -> CGFloat {
        self = self * self
        return self * self
    }
    
    var string: String {
        return "\(self)"
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
