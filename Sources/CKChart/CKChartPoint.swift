//
//  CKChartPoint.swift
//  CKit
//
//  Created by CHU on 2017/7/4.
//
//

import Foundation

open class CKChartPoint {
    final public var x: Double = 0
    final public var y: Double = 0
    final public var name: String?
    
    convenience init(x: Double = 0, y: Double = 0) {
        self.init()
        
        self.x = x
        self.y = y
    }
    
    convenience init(value: Double) {
        self.init(x: value)
    }
}

extension CKChartPoint: CKChartDataPoint {
    
}

open class CKChartDataBound {
    var minX: Double = 0
    var maxX: Double = 0
    var minY: Double = 0
    var maxY: Double = 0
    
    init(x: [Double], y: [Double]) {
        minX = x.min()!
        minY = y.min()!
        maxX = x.max()!
        maxY = y.max()!
    }
}

public protocol CKChartDataPoint {
    var x: Double { get }
    var y: Double { get }
    var name: String? { get }
}
