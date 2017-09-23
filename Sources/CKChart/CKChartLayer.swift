//
//  CKChartGroupView.swift
//  CKit
//
//  Created by CHU on 2017/7/4.
//
//

import UIKit

open class CKChartLayer: CAShapeLayer {
    final public var points = [CKChartPoint]()
    @objc final public var allX: [Double] {
        return points.map { (p) -> Double in
            return p.x
        }
    }
    @objc final public var allY: [Double] {
        return points.map { (p) -> Double in
            return p.y
        }
    }
    @objc final public var pointImage: UIImage?
    final public var baseDelegate: CKChartLayerDelegate?
    
    final fileprivate let shapeLayer = CAShapeLayer()
    final fileprivate let pointsLayer = CAShapeLayer()
    
    public override init() {
        super.init()
        
        addSublayer(shapeLayer)
        addSublayer(pointsLayer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    final public func add(point: CKChartPoint) {
        points.append(point)
    }
}

public protocol CKChartLayerDelegate {
    var drawingBound: CGRect { get }
    var dataBound: CKChartDataBound { get }
    func redraw(_ sender: CKChartLayer?) -> Void
}

public enum CKChartGroupTypes {
    case line, cubicLine, bar, scatter
}
