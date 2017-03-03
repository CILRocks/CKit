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
    func render<V: CKViewType>(in view: V)
}

public extension CKModelType {
    func render<V : CKViewType>(in view: V) {
        view.render(self)
    }
}
