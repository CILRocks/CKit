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
    
    public extension UIApplication {
        var isFullscreen: Bool {
            guard let w = self.delegate?.window, let window = w else { return false }
            return window.frame.equalTo(window.screen.bounds)
        }
    }
    
    public extension UIStoryboard {
        static var main: UIStoryboard {
            return UIStoryboard(name: "Main", bundle: .main)
        }
    }
    
    public extension UIView {
        var uiImage: UIImage? {
            return UIImage(view: self).resized(to: bounds.size)
        }
        
        func addConstraint(withWidthEqualTo width: CGFloat) {
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
        }
        
        func addConstraint(withHieghtEqualTo width: CGFloat) {
            self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
        }
    }
    
    public extension UITableView {
        func reloadDataWithAnimation(_ animation: UITableViewRowAnimation = .automatic) {
            let sections = IndexSet(integersIn: 0...self.numberOfSections - 1)
            self.reloadSections(sections, with: animation)
        }
    }
    
    public extension UIFont {
        func change(weight: String?, size: CGFloat?) -> UIFont {
            let name = self.fontName.components(separatedBy: "-").first!
            return UIFont(name: weight == nil ? self.fontName : "\(name)-\(weight!)", size: size ?? self.pointSize)!
        }
    }
    
    public extension UIImage {
        /**
         - source: stackoverflow.com/questions/30696307/how-to-convert-a-uiview-to-a-image
         */
        convenience init(view: UIView) {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.init(cgImage: image!.resized(to: view.bounds.size)!.cgImage!)
        }
        
        func resized(to aSize: CGSize) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(aSize, false, 0.0)
            draw(in: aSize.cgRect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
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
    
    public protocol CKChildViewType {
        func willAppear(_ animated: Bool) -> Void
        func didAppear(_ animated: Bool) -> Void
        func willDisappear(_ animated: Bool) -> Void
        func didDisappear(_ animated: Bool) -> Void
        func willResize() -> Void
        func willLayout() -> Void
        func didLayout() -> Void
    }
    
    extension UIView: CKChildViewType {
        open func didDisappear(_ animated: Bool) { }
        open func willDisappear(_ animated: Bool) { }
        open func didAppear(_ animated: Bool) { }
        open func willAppear(_ animated: Bool) { }
        open func willResize() { }
        open func willLayout() { }
        open func didLayout() { }
    }
    
    open class CKViewController: UIViewController {
        @IBOutlet var viewEventListeners: [UIView]!
        
        open override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            for ckView in viewEventListeners {
                ckView.willAppear(animated)
            }
        }
        
        open override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            for ckView in viewEventListeners {
                ckView.didAppear(animated)
            }
        }
        
        open override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            for ckView in viewEventListeners {
                ckView.willDisappear(animated)
            }
        }
        
        open override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            for ckView in viewEventListeners {
                ckView.didDisappear(animated)
            }
        }
        
        open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            for ckView in viewEventListeners {
                ckView.willResize()
            }
        }
        
        open override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            for ckView in viewEventListeners {
                ckView.willLayout()
            }
        }
        
        open override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            for ckView in viewEventListeners {
                ckView.didLayout()
            }
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

public extension CGSize {
    var cgRect: CGRect {
        return CGRect(origin: CGPoint.zero, size: self)
    }
    
    func cgRect(origin: CGPoint) -> CGRect {
        return CGRect(origin: origin, size: self)
    }
    
    func cgRect(origin: [CGFloat]) -> CGRect {
        return CGRect(origin: origin.cgPoint, size: self)
    }
}

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
