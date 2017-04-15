//
//  CKIMisc.swift
//  CKit
//
//  Created by CHU on 2017/4/14.
//
//

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
    
    public extension UIScreen {
        var isLandscape: Bool {
            return bounds.width > bounds.height
        }
    }
    
    open class CKBezierPath: UIBezierPath {
        open func move(to point: [CGFloat]) {
            move(to: point.cgPoint)
        }
        
        open func addLine(to point: [CGFloat]) {
            addLine(to: point.cgPoint)
        }
        
        open func addQuadCurve(to endPoint: [CGFloat], controlPoint: [CGFloat]) {
            addQuadCurve(to: endPoint.cgPoint, controlPoint: controlPoint.cgPoint)
        }
        
        open func addCurve(to endPoint: [CGFloat], controlPoint1: [CGFloat], controlPoint2: [CGFloat]) {
            addCurve(to: endPoint.cgPoint, controlPoint1: controlPoint1.cgPoint, controlPoint2: controlPoint2.cgPoint)
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
    
    open class CKBezierPath: NSBezierPath {
        open func move(to point: [CGFloat]) {
            move(to: point.cgPoint)
        }
        
        open func line(to point: [CGFloat]) {
            line(to: point.cgPoint)
        }
        
        open func curve(to endPoint: [CGFloat], controlPoint1: [CGFloat], controlPoint2: [CGFloat]) {
            curve(to: endPoint.cgPoint, controlPoint1: controlPoint1.cgPoint, controlPoint2: controlPoint2.cgPoint)
        }
    }
#endif

extension NSLayoutConstraint {
//    override open var description: String {
//        let id = identifier ?? ""
//        return "id: \(id), constant: \(constant), \(firstItem.description))"
//    }
    
    public func setMultiplier(_ aCGFloat: CGFloat) {
        NSLayoutConstraint.deactivate([self])
        
        let new = NSLayoutConstraint(item: firstItem, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: aCGFloat, constant: constant)
        new.priority = priority
        new.shouldBeArchived = shouldBeArchived
        new.identifier = identifier
        
        NSLayoutConstraint.activate([new])
    }
}
