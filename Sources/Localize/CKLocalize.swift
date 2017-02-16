//
//  CKLocalize.swift
//  CKit
//
//  Created by CHU on 2017/2/14.
//
//

import Foundation

public class CKLocalize {
    public static func get(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    public static func get(_ key: String, arg: CVarArg) -> String {
        return String(format: get(key), arg)
    }
    
    public static func get(_ key: String, args: [CVarArg]) -> String {
        return String(format: get(key), arguments: args)
    }
}
