//
//  CKChartBase.swift
//  CKit
//
//  Created by CHU on 2017/7/4.
//
//

import UIKit

open class CKChart: UIView {
    @objc public var isInteractionEnabled = false
    final public var delegate: CKChartDelegate?
    
    @IBInspectable final public var vGuideColor: UIColor = .clear
    @IBInspectable final public var hGuideColor: UIColor = .clear
    @IBInspectable final public var xAxisColor: UIColor = .clear
    @IBInspectable final public var yAxisColor: UIColor = .clear
    @IBInspectable final public var xAxisDoubled: Bool = false
    @IBInspectable final public var yAxisDoubled: Bool = false
    @IBInspectable final public var xAxisNumber: Bool = true
    @IBInspectable final public var yAxisNumber: Bool = true
    @IBInspectable final public var xAxisReversed: Bool = false
    
    final private var layers = [CKChartLayer]()
    final private let axisLayer = CAShapeLayer()
    final private let guideLayer = CAShapeLayer()
    @objc final public var drawingBound: CGRect {
        return bounds
    }
    final public var dataBound: CKChartDataBound {
        let x = layers.map { $0.allX.min()! } + layers.map { $0.allX.max()! }
        let y = layers.map { $0.allY.min()! } + layers.map { $0.allY.max()! }
        return CKChartDataBound(x: x, y: y)
    }
    
    open override var bounds: CGRect {
        didSet {
            if bounds.width == oldValue.width && bounds.height == oldValue.height { return }
            redraw()
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc open func add(layer: CKChartLayer) {
        layer.baseDelegate = self
        layers.append(layer)
        layer.addSublayer(layer)
    }
    
    fileprivate func resize(_ target: [CKChartLayer] = []) {
        for l in target.count == 0 ? layers : target {
            l.bounds = frame
        }
    }
}

extension CKChart: CKChartLayerDelegate {
    @objc public func redraw(_ sender: CKChartLayer? = nil) {
        resize()
    }
}

public protocol CKChartDelegate {
    func userDidSelect(dataPoint: CKChartPoint) -> Void
}
