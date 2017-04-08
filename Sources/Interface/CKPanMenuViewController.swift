//
//  CKPanMenuViewController.swift
//  CKit
//
//  Created by CHU on 2017/2/15.
//
//

import UIKit

@available(iOS 9.0, *)
@IBDesignable open class CKPanMenuViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet public weak var menuView: UIStackView!
    //Clockwise constraints
    @IBOutlet public var menuViewConstraints: [NSLayoutConstraint]!
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    
    public var position: PanMenuScreenPosition = .top
    public var items = [CKPanMenuItemType]()
    @IBInspectable public var fontSize: CGFloat = 15
    @IBInspectable public var color: UIColor = .black
    @IBInspectable public var spacing: CGFloat = 20
    public var endMargin: CGFloat = 0
    private var selected: Int? {
        didSet {
            if selected != nil && items.count > 0 {
                for item in items {
                    item.index == selected! ? item.highlight() : item.resume()
                }
            }
        }
    }
    
    public var isEnabled = true {
        didSet {
            panGestureRecognizer.isEnabled = isEnabled
        }
    }
    
    public enum MenuType {
        case floatContent
        case fixContent
    }
    
    public enum PanMenuScreenPosition {
        case top
        case bottom
        case left
        case right
    }
    
    public enum PanMenuAxis {
        case horizontal
        case vertical
    }
    
    public var axis: PanMenuAxis {
        if position == .top || position == .bottom {
            return .vertical
        } else {
            return .horizontal
        }
    }
    
    public var isVertical: Bool {
        return axis == .vertical
    }
    
    public var isHorizontal: Bool {
        return axis == .horizontal
    }
    
    public var directionFactor: CGFloat {
        if position == .top || position == .left {
            return 1.0
        } else {
            return -1.0
        }
    }
    
    public var threshold: CGFloat {
        return spacing + fontSize
    }
    
    public var itemLength: CGFloat {
        if isVertical {
            return items[0].bounds.height
        } else {
            return items[0].bounds.width
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Pan gesture
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(contentDidPan(_:)))
        panGestureRecognizer.delegate = self
        contentView.addGestureRecognizer(panGestureRecognizer)
        //Menu view
        menuView.axis = isVertical ? .vertical : .horizontal
        menuView.alignment = .center
        menuView.spacing = spacing
        switch position {
        case .top:
            menuViewConstraints[0].constant = spacing
            view.removeConstraint(menuViewConstraints[2])
        case .right:
            menuViewConstraints[1].constant = spacing
            view.removeConstraint(menuViewConstraints[3])
        case .bottom:
            menuViewConstraints[2].constant = spacing
            view.removeConstraint(menuViewConstraints[0])
        case .left:
            menuViewConstraints[3].constant = spacing
            view.removeConstraint(menuViewConstraints[1])
        }
        menuView.setNeedsUpdateConstraints()
    }
    
    final public func addItem(title: String, action: @escaping (Int) -> Void) {
        let item = CKPanMenuItem()
        item.font = UIFont(name: item.font.fontName, size: fontSize)
        item.index = items.count
        item.action = action
        item.text = title
        item.textColor = color
        item.resume()
        if directionFactor == 1 {
            items.append(item)
            menuView.addArrangedSubview(item)
        } else {
            items.insert(item, at: 0)
            menuView.insertArrangedSubview(item, at: 0)
        }
    }
    
    final public func addItem(_ item: CKPanMenuItemType) {
        var item = item
        item.index = items.count
        directionFactor == 1 ? items.append(item) : items.insert(item, at: 0)
        directionFactor == 1 ? menuView.addArrangedSubview(item as! UIView) : menuView.insertArrangedSubview(item as! UIView, at: 0)
    }
    
    final public func contentDidPan(_ sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translation = sender.translation(in: view)
        var origin, limit, end: CGFloat!
        if isVertical {
            origin = 20 + contentView.bounds.height / 2
            end = origin + translation.y
        } else {
            origin = contentView.bounds.width / 2
            end = origin + translation.x
        }
        let temp = spacing + items.count.cgFloat * (spacing + fontSize) + endMargin
        limit = origin + temp * directionFactor
        //Calculate and set position
        if directionFactor == 1.0 {
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
        if isVertical {
            contentView.layer.position.y = end
        } else {
            contentView.layer.position.x = end
        }
        //Detect selected menu item
        let diff = abs(end - origin)
        var aSelected: Int? = ((diff - spacing - itemLength) / (itemLength + spacing)).rounded(.down).int
        //print((diff, itemLength + spacing, selected!))
        let min = spacing + fontSize + (fontSize + spacing) * aSelected!.cgFloat
        let max = min + spacing + 4
        if diff < min || diff > max {
            aSelected = nil
        }
        selected = aSelected
        //Pan gesture end
        if state == .ended {
            if isVertical {
                UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                    self.contentView.layer.position.y = origin
                })
            } else {
                UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                    self.contentView.layer.position.x = origin
                })
            }
            //Check if ativate a menu item
            if selected != nil {
                if selected! >= 0 && selected! < items.count {
                    items[selected!].action(selected!)
                }
            }
        }
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

public protocol CKPanMenuItemType {
    var index: Int! { get set }
    var action: (Int) -> Void { get set }
    var title: String! { get set }
    var reason: String? { get set }
    var isEnabled: Bool { get set }
    var bounds: CGRect { get set }
    
    func highlight() -> Void
    func resume() -> Void
}

open class CKPanMenuItem: UILabel, CKPanMenuItemType {
    public var index: Int! = 0
    public var action: (Int) -> Void = { _ in }
    public var title: String!
    public var reason: String?
    
    open override var isEnabled: Bool {
        didSet {
            if isEnabled {
                text = title
            } else {
                let r = reason == nil ? "" : reason!
                text = "\(title) (\(r))"
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        textAlignment = .center
        layer.opacity = 0.48
    }
    
    open func highlight() {
        UIView.animate(withDuration: 0.16, delay: 0, options: .curveEaseInOut, animations: {
            self.layer.opacity = 0.87
        })
    }
    
    open func resume() {
        UIView.animate(withDuration: 0.16, delay: 0, options: .curveEaseInOut, animations: {
            self.layer.opacity = 0.48
        })
    }
}
