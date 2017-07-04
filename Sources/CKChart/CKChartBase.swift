//
//  CKChartBase.swift
//  CKit
//
//  Created by CHU on 2017/7/4.
//
//

import UIKit

open class CKChartBase: UIView {
    public var isInteractionEnabled = false
    
    @IBInspectable public var vGuideColor: UIColor = .clear
    @IBInspectable public var hGuideColor: UIColor = .clear
    @IBInspectable public var xAxisColor: UIColor = .clear
    @IBInspectable public var yAxisColor: UIColor = .clear
    @IBInspectable public var xAxisDoubled: Bool = false
    @IBInspectable public var yAxisDoubled: Bool = false
    @IBInspectable public var xAxisReversed: Bool = false
    
    final public func add(group: CKChartGroup) {
        
    }
}

public protocol CKChartBaseDelegate {
    func userDidSelect(dataPoint: CKChartPoint) -> Void
}
