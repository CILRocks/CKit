import Foundation
#if os(iOS)
    import UIKit
#endif

#if os(OSX)
    import AppKit
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
    public extension UIDevice {
        /**
         A `bool` that indicates whether the current device is iPhone.
         */
        static var isPhone: Bool {
            return current.userInterfaceIdiom == .phone
        }
    }
#endif

#if os(OSX)
    
#endif

public extension IndexPath {
    init(_ row: Int, section: Int = 0) {
        self.init(row: row, section: section)
    }
}

public extension NSLocale {
    /**
     A `bool` that indicates whether the region of current `nsLocale` is China.
     */
    static var isChina: Bool {
        return NSLocale.current.regionCode == "CN"
    }
    
    /**
     The string representation of the `NSLocale` in the format of languageCode-regionCode
     */
    static var languageRegionCode: String {
        return "\(self.current.languageCode!)-\(self.current.regionCode!)"
    }
}

public extension NSDate {
    /**
     The `date` representation of the `nsDate`.
     */
    var date: Date {
        return Date(timeIntervalSince1970: self.timeIntervalSince1970)
    }
}

public extension Date {
    /**
     The `nsDate` representation of the `date`.
     */
    var nsDate: NSDate {
        return NSDate(timeIntervalSince1970: self.timeIntervalSince1970)
    }
}

public extension String {
    /**
     The `character` at the given index of the `string`.
     
     - parameter i: The index.
     */
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    /**
     The one `character` `string` at the given index of the `string`.
     
     - parameter i: The index.
     */
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    /**
     The `string` in the given `range` of the `string`.
     
     - parameter r: The `range`.
     */
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start..<end]
    }
    
    /**
     The `string` in the given `closedRange` of the `string`.
     
     - parameter r: The `closedRange`.
     */
    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start...end]
    }
    
    /**
     The `int` representation of the `string`.
     */
    var int: Int? {
        return Int(self)
    }
    
    /**
     The Core Graphic `float` representation of the `string`.
     */
    var cgFloat: CGFloat? {
        let float = self.float
        guard float != nil else {
            return nil
        }
        return CGFloat(self.float!)
    }
    
    /**
     The `float` representation of the `string`.
     */
    var float: Float? {
        return Float(self)
    }
    
    /**
     The `double` representation of the `string`.
     */
    var double: Double? {
        return Double(self)
    }
    
    /**
     The `nsString` representation of the `string`.
     */
    var nsString: NSString {
        return NSString(string: self)
    }
    
    /**
     Generate a random `string` with given length.
     
     - parameter length: The length of the generated `string`.
     */
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
    
    /**
     Get a new `string` with first letter capitalized.
     */
    func capitalizedFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    /**
     Capitalize the first letter of the `string`.
     */
    mutating func capitalizeFirstLetter() {
        self = self.capitalizedFirstLetter()
    }
    
    /**
     Escape the `string`.
     */
    mutating func escape() {
        var new = self.replacingOccurrences(of: "\"", with: "\"\"")
        if new.contains(",") || new.contains("\n") {
            new = String(format: "\"%@\"", new)
        }
        self = new
    }
    
    /**
     Get a new `string` that encoded for URI.
     */
    var encodedURI: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    /**
     Get a new escaped `string`.
     */
    var escaped: String {
        var new = self.replacingOccurrences(of: "\"", with: "\"\"")
        if new.contains(",") || new.contains("\n") {
            new = String(format: "\"%@\"", new)
        }
        return new
    }
    
    /**
     Format the `string` with given format string.
     
     - parameter format: Will use this parameter to format the `string`.
     */
    mutating func format(using format: String) {
        self = self.formatted(using: format)
    }
    
    /**
     Get a new `string` that formatted with given format string.
     
     - parameter format: Will use this parameter to format the `string`.
     */
    func formatted(using format: String) -> String {
        return String(format: format, self)
    }
    
    /**
     Add a string to the beginning of the `string`.
     
     - parameter aString: The prefix string.
     */
    mutating func prefix(_ aString: String) {
        self = "\(aString)\(self)"
    }
}

extension String: Error {}

public extension Bool {
    /**
     Initialize a `bool` from given `int`.
     
     - parameter int: A `int` that should only be `0` or `1`.
     
     - note: this method will throw if the given `int` does not meet the requirement.
     */
    init(fromInt int: Int) throws {
        self.init()
        
        if int != 0 && int != 1 {
            throw "Trying to create bool from a non zero or one integer."
        }
        self = int == 1
    }
    
    /**
     The `int` representation of the `bool`.
     */
    var int: Int {
        return self ? 1 : 0
    }
    
    /**
     The `string` representation of the `bool`.
     */
    var string: String {
        return self.description
    }
    
    /**
     Reverse the `bool`.
     */
    mutating func reverse() {
        self = !self
    }
    
    /**
     Get a new reversed `bool`.
     */
    var reversed: Bool {
        return !self
    }
}

public extension Array {
    /**
     Get a new shuffled `array`.
     */
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
    
    /**
     Get a new Core Graphic point that initialized with the `array`.
     - note: Will return a zero point if the array doesn't meet the requirement.
     */
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
    /**
     A `bool` that indicates whether it's the first launch of the app.
     */
    static var isFirstLaunch: Bool {
        let flag = "FirstLaunchFlag"
        
        if !UserDefaults.standard.bool(forKey: flag) {
            UserDefaults.standard.set(true, forKey: flag)
            return true
        }
        return false
    }
}

public extension LazyMapRandomAccessCollection {
    /**
     The `array` representation of the `lazyMapRandomAccessCollection`.
     */
    var array: [Any] {
        return Array(self)
    }
}
