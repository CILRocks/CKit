//
//  CKChartGroupView.swift
//  CKit
//
//  Created by CHU on 2017/7/4.
//
//

import UIKit

open class CKChartGroupView: UIView {
    
}

public enum CKChartGroupTypes {
    case line, cubicLine, bar, scatter
}

open class CKChartGroup {
    final public var points = [CKChartPoint]()
    final public var type: CKChartGroupTypes = .line
    final public var pointImage: UIImage?
    final public var pointPath: CGPath?
    final public var view: CKChartGroupView?
}
