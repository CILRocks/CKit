//
//  CKViewModel.swift
//  CKit
//
//  Created by CHU on 2017/3/3.
//
//

import Foundation

public protocol CKViewType {
    func render<M: CKModelType>(_ model: M)
}

public protocol CKModelType {
    func renderInView<V: CKViewType>(_ view: V)
}

public extension CKModelType {
    func renderInView<V : CKViewType>(_ view: V) {
        view.render(self)
    }
}
