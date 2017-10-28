//
//  SwiftFile.swift
//  SwiftCTimePackageDescription
//
//  Created by ooatuoo on 2017/10/15.
//

import Foundation
import PathKit

public struct SwiftFile {
    let path: Path
    let shouldSort: Bool
    let shouldShowFucLoc: Bool
    
    init(path: Path, shouldSort: Bool, shouldShowFucLoc: Bool) {
        self.path = path
        self.shouldSort = shouldSort
        self.shouldShowFucLoc = shouldShowFucLoc
    }
    
    public func run() {
        let result = compile()  
        var funcResults = result.funcResults
        
        if shouldSort {
            funcResults.sort(by: { $0.compileTime > $1.compileTime })
        }
        
        print("\n============== \(path.lastComponent) ==============")
        let funcInfo = funcResults.map { $0.getConsoleOutput(showFuncLoc: shouldShowFucLoc) }
                                    .joined(separator: "\n\n")
        print(funcInfo)
        
        if !result.errInfo.isEmpty {
            print("\n--- error: ".red)
            print(result.errInfo.joined(separator: "\n"))
        }
        print("\n")
    }
    
    fileprivate func compile() -> (funcResults: [FuncCompileResult], errInfo: [String]) {
        let output = SwiftCompileProcess(path: path).execute()
        let results = output.components(separatedBy: "\n").dropLast()
        
        let fileName = path.lastComponent
        var funcResults: [FuncCompileResult] = []
        var errInfo: [String] = []
        
        for result in results {
            if let funcResult = FuncCompileResult(result: result, fileName: fileName) {
                funcResults.append(funcResult)
            } else {
                errInfo.append(result)
            }
        }
        
        return (funcResults.filter{ $0.isUseful }, errInfo)
    }
}

