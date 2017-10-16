//
//  FuncCompileResult.swift
//  SwiftCTimePackageDescription
//
//  Created by ooatuoo on 2017/10/15.
//

import Foundation
import Rainbow

public struct FuncCompileResult {
    let funcName: String
    let compileTime: Float
    let funcLoc: String
    
    init?(result: String, fileName: String) {
        let info = result.components(separatedBy: "\t")
        guard info.count == 3 else { return nil }

        var locInfo = info[1]
        if let range = locInfo.range(of: "\(fileName):") {
            locInfo.removeSubrange(range)
        }
        
        compileTime = Float(info[0].dropLast(2)) ?? 0
        funcName = info[2]
        funcLoc = "<\(locInfo)>"
    }
    
    var isUseful: Bool {
        if funcLoc.contains("<invalid loc>") {
            return false
        }
        
        if funcName == "get {}" || funcName == "set {}" {
            return false
        }
        
        return true
    }
    
    var colorfulDescription: String {
        var str = String(format: "%.2fms", compileTime).lightGreen + "\t"
        str += funcLoc + "\t"
        str += funcName.green
        return str
    }
}

