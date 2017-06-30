//
//  CKPanMenuViewController.swift
//  CKit
//
//  Created by CHU on 2017/2/15.
//
//

#if os(iOS)
    import UIKit
    
    @available(iOS 9.0, *)
    open class CKPanMenuViewController: CKViewController, UIGestureRecognizerDelegate {
        @IBOutlet public weak var contentView: UIView!
        @IBOutlet public weak var menuView: UIStackView!
        //Clockwise constraints
        @IBOutlet public var menuViewConstraints: [NSLayoutConstraint]!
        private var menuViewBaseConstraintIndex = 0
        fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
        fileprivate var perpendicularPanGestureRecognizer: UIPanGestureRecognizer!
        public var safeZone: CGRect!
        
        public var position: PanMenuScreenPosition = .top
        public var items = [CKPanMenuItemType]() {
            didSet {
                isEnabled = items.count != 0
            }
        }
        public var fontSize: CGFloat = 15
        public var fontName: String?
        public var color: UIColor = .black
        public var spacing: CGFloat = 20 {
            didSet {
                menuView.spacing = spacing
                menuViewConstraints[menuViewBaseConstraintIndex].constant = spacing
            }
        }
        public var endMargin: CGFloat = 0
        private var selected: Int! {
            didSet {
                for item in items {
                    item.index == selected ? item.highlight() : item.resume()
                }
            }
        }
        
        public var isEnabled = false {
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
            if items.count == 0 {
                return 0
            } else {
                if isVertical {
                    return items[0].bounds.height
                } else {
                    return items[0].bounds.width
                }
            }
        }

        override open func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            //Pan gesture
            safeZone = view.bounds
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(contentDidPan(_:)))
            panGestureRecognizer.maximumNumberOfTouches = 1
            panGestureRecognizer.delegate = self
            contentView.addGestureRecognizer(panGestureRecognizer)
            perpendicularPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(contentDidPanPerpendicular(_:)))
            perpendicularPanGestureRecognizer.maximumNumberOfTouches = 1
            perpendicularPanGestureRecognizer.delegate = self
            contentView.addGestureRecognizer(perpendicularPanGestureRecognizer)
            //Menu view
            menuView.axis = isVertical ? .vertical : .horizontal
            menuView.alignment = .center
            //Item spacing and menuView distance to super view
            switch position {
            case .top:
                menuViewBaseConstraintIndex = 0
                view.removeConstraint(menuViewConstraints[2])
            case .right:
                menuViewBaseConstraintIndex = 1
                view.removeConstraint(menuViewConstraints[3])
            case .bottom:
                menuViewBaseConstraintIndex = 2
                view.removeConstraint(menuViewConstraints[0])
            case .left:
                menuViewBaseConstraintIndex = 3
                view.removeConstraint(menuViewConstraints[1])
            }
            menuView.spacing = spacing
            isVertical ? (menuView.frame.size.height = 0) : (menuView.frame.size.width = 0)
            
            menuView.setNeedsUpdateConstraints()
        }
        
        /**
         Init and append a `menu item`.
         
         - parameter itemWithTitle: `item title`.
         - parameter action: an `action` that will be executed when user highlight and release finger on an `menu item`.
         
         - author: John Cido
         */
        final public func append(itemWithTitle title: String, action: @escaping (inout CKPanMenuItemType) -> Void) {
            let item = CKPanMenuItem()
            item.font = UIFont(name: fontName != nil ? fontName! : item.font.fontName, size: fontSize)
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
        
        /**
         Init and insert a `menu item` at `index`.
         
         - parameter itemWithTitle: `item title`.
         - parameter action: an `action` that will be executed when user highlight and release finger on an `menu item`.
         - parameter at: specify `index` that item should be insert at
         
         - author: John Cido
         */
        final public func insert(
            itemWithTitle title: String, action: @escaping (inout CKPanMenuItemType) -> Void, at index: Int
            ) {
            let item = CKPanMenuItem()
            item.font = UIFont(name: fontName != nil ? fontName! : item.font.fontName, size: fontSize)
            item.index = items.count
            item.action = action
            item.text = title
            item.textColor = color
            item.resume()
            if directionFactor == 1 {
                items.insert(item, at: index)
                menuView.insertArrangedSubview(item, at: index)
            } else {
                items.insert(item, at: items.count - 1 - index)
                menuView.insertArrangedSubview(item, at: items.count - 1 - index)
            }
        }
        
        /**
         Append a custome defined `menu item`.
         
         - parameter item: an `item title` that conforms to `protocol CKPanMenuItemType`.
         
         - author: John Cido
         */
        final public func append(item: CKPanMenuItemType) {
            var item = item
            item.index = items.count
            directionFactor == 1 ? items.append(item) : items.insert(item, at: 0)
            directionFactor == 1 ? menuView.addArrangedSubview(item as! UIView) : menuView.insertArrangedSubview(item as! UIView, at: 0)
        }
        
        public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            switch gestureRecognizer {
            case panGestureRecognizer:
                let velocity = panGestureRecognizer.velocity(in: view)
                let factor: CGFloat = 1.2
                let result = isVertical ? abs(velocity.x) * factor < abs(velocity.y)
                    : abs(velocity.y) * factor < abs(velocity.x)
                return result
            case perpendicularPanGestureRecognizer:
                let velocity = panGestureRecognizer.velocity(in: view)
                let factor: CGFloat = 1.2
                let result = isVertical ? abs(velocity.x) > abs(velocity.y) * factor
                    : abs(velocity.y) > abs(velocity.x) * factor
                return result
            default:
                return true
            }
        }
        
        public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let a = gestureRecognizer == panGestureRecognizer && otherGestureRecognizer == perpendicularPanGestureRecognizer
        let b = gestureRecognizer == perpendicularPanGestureRecognizer && otherGestureRecognizer == panGestureRecognizer
            return a || b
        }
        
        open func contentDidPanPerpendicular(_ recognizer: UIPanGestureRecognizer) { }
        
        open func contentDidPan(_ recognizer: UIPanGestureRecognizer) {
            if isEnabled {
            let state = recognizer.state
            let translation = recognizer.translation(in: view)
            
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
            var aSelected = ((diff - spacing - itemLength) / (itemLength + spacing)).rounded(.down).int
            if directionFactor != 1 {
                aSelected = items.count - 1 - aSelected
            }
            //print((diff, itemLength + spacing, selected!))
            let min = spacing + fontSize + (fontSize + spacing) * aSelected.cgFloat
            let max = min + spacing
            if diff < min || diff > max {
                aSelected = -1
            }
            selected = aSelected
            //Pan gesture end
            if state == .ended {
                if isVertical {
                    UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                        [weak self] in
                        self?.contentView.layer.position.y = origin
                    })
                } else {
                    UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                        [weak self] in
                        self?.contentView.layer.position.x = origin
                    })
                }
                //Check if ativate a menu item
                if selected != nil {
                    if selected! >= 0 && selected! < items.count {
                        items[selected!].action(&items[selected!])
                    }
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
        var action: (inout CKPanMenuItemType) -> Void { get set }
        var title: String! { get set }
        var reason: String? { get set }
        var isEnabled: Bool { get set }
        var bounds: CGRect { get set }
        
        func highlight() -> Void
        func resume() -> Void
    }

    open class CKPanMenuItem: UILabel, CKPanMenuItemType {
        public var index: Int! = 0
        public var action: (inout CKPanMenuItemType) -> Void = { _ in }
        public var title: String! {
            didSet {
                text = title
            }
        }
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
#endif
