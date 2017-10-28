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
        
        funcName = parseFuncName(info[2])
        compileTime = Float(info[0].dropLast(2)) ?? 0
        funcLoc = "<\(locInfo)>"
    }
    
    public var isUseful: Bool {
        if funcLoc.contains("<invalid loc>") {
            return false
        }
        
        if funcName.contains("get {}")
            || funcName.contains("set {}")
            || funcName == "(closure)" {
            return false
        }
        
        return true
    }
    
    public func getConsoleOutput(showFuncLoc: Bool) -> String {
        // \u{001B}[0;33myellow
        var str = String(format: "%.2fms", compileTime).green + "\t"
        if showFuncLoc { str += funcLoc + " - " }
        str += funcName.bold
        return str
    }
}

// MARK: - Helper Method

fileprivate func parseFuncName(_ funcName: String) -> String {
    guard let checkReg = try? NSRegularExpression(pattern: "static|class|.\\s+func", options: []),
        let replaceReg = try? NSRegularExpression(pattern: "\\s{2,}|\\t", options: []) else {
            return funcName
    }
    
    let fullRange = NSMakeRange(0, funcName.count)
    guard let _ = checkReg.firstMatch(in: funcName, options: [], range: fullRange) else {
        return funcName
    }
    
    return replaceReg.stringByReplacingMatches(in: funcName, options: [], range: fullRange, withTemplate: " ")
}


