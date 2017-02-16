//
//  CKPanMenuViewController.swift
//  CKit
//
//  Created by CHU on 2017/2/15.
//
//

import UIKit

@IBDesignable open class CKPanMenuViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet public var menuItems: [CKPanMenuItem]!
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    public var panMenuPosition: PanMenuScreenPositions = .top
    public var menuActions: [Int: () -> Void]!
    public var endMargin: CGFloat = 0
    public var triggerThreshold: CGFloat = 40
    public var panEnabled = true
    
    public struct PanMenuScreenPositions: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        static let top = PanMenuScreenPositions(rawValue: 1 << 0)
        static let bottom = PanMenuScreenPositions(rawValue: 1 << 1)
        static let left = PanMenuScreenPositions(rawValue: 1 << 2)
        static let right = PanMenuScreenPositions(rawValue: 1 << 3)
    }
    
    public struct PanMenuAxises: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        static let horizontal = PanMenuAxises(rawValue: 1 << 0)
        static let vertical = PanMenuAxises(rawValue: 1 << 1)
    }
    
    public var menuItemLength: CGFloat {
        if isVerticalPan {
            return (menuItems.first?.bounds.height)!
        } else {
            return (menuItems.first?.bounds.width)!
        }
    }
    
    public var panAxis: PanMenuAxises {
        if panMenuPosition == .top || panMenuPosition == .bottom {
            return .vertical
        } else {
            return .horizontal
        }
    }
    
    public var isVerticalPan: Bool {
        return panAxis == .vertical
    }
    
    public var isHorizontalPan: Bool {
        return panAxis == .horizontal
    }
    
    public var axisDirectionFactor: CGFloat {
        if panMenuPosition == .top || panMenuPosition == .left {
            return 1.0
        } else {
            return -1.0
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        panGestureRecognizer = UIPanGestureRecognizer(
            target: self, action: #selector(contentDidPan(_:)))
        panGestureRecognizer.delegate = self
        contentView.addGestureRecognizer(panGestureRecognizer)
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func contentDidPan(_ sender: UIPanGestureRecognizer) {
        if panEnabled {
            let state = sender.state
            let translation = sender.translation(in: view)
            var origin, limit, end: CGFloat!
            if isVerticalPan {
                origin = 20 + contentView.bounds.height / 2
                end = origin + translation.y
            } else {
                origin = contentView.bounds.width / 2
                end = origin + translation.x
            }
            limit = origin + menuItemLength * (menuItems.count.cgFloat + endMargin) * axisDirectionFactor
            //Calculate and set position
            if axisDirectionFactor == 1.0 {
                if end > limit {
                    end = limit
                }
                if end < origin {
                    end = origin
                }
            } else {
                if end < limit {
                    end = limit
                }
                if end > origin {
                    end = origin
                }
            }
            if isVerticalPan {
                contentView.layer.position.y = end
            } else {
                contentView.layer.position.x = end
            }
            //Detect selected menu item
            let diff = abs(end - origin)
            var selected = (diff / menuItemLength - 0.3).int
            if diff < triggerThreshold {
                selected = -1
            }
            NotificationCenter.default.post(name: .CKPanMenuSelectedIndexDidChange, object: selected)
            //Pan gesture end
            if state == .ended || state == .cancelled {
                if isVerticalPan {
                    UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                        self.contentView.layer.position.y = origin
                    }, completion: { _ in })
                } else {
                    UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                        self.contentView.layer.position.x = origin
                    }, completion: { _ in })
                }
                //Check if ativate a menu item
                if selected != -1 {
                    if menuActions[selected] != nil {
                        menuActions[selected]!()
                    }
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

open class CKPanMenuItem: UIButton {
    @IBInspectable var itemIndex: Int = 0
    
    override open func awakeFromNib() {
        layer.opacity = 0.48
        titleLabel?.textAlignment = .center
        
        NotificationCenter.default.addObserver(
            forName: .CKPanMenuSelectedIndexDidChange,
            object: nil, queue: nil) { (notification) in
                let index = notification.object as! Int
                if self.itemIndex == index {
                    self.highlight()
                } else {
                    self.resume()
                }
        }
    }
    
    open func highlight() {
        UIView.animate(withDuration: 0.16, delay: 0, options: .curveEaseInOut, animations: {
            self.layer.opacity = 1
        }) { (_) in }
    }
    
    open func resume() {
        UIView.animate(withDuration: 0.16, delay: 0, options: .curveEaseInOut, animations: {
            self.layer.opacity = 0.48
        }) { (_) in }
    }
}

fileprivate extension NSNotification.Name {
    static var CKPanMenuSelectedIndexDidChange: NSNotification.Name {
        return NSNotification.Name("CKPanMenuSelectedIndexDidChange")
    }
}
