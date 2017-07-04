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
    
    convenience init(x: Double = 0, y: Double = 0) {
        self.init()
        
        self.x = x
        self.y = y
    }
    
    convenience init(value: Double) {
        self.init(x: value)
    }
}
