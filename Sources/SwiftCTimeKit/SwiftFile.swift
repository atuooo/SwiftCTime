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
    
    init(path: Path, shouldSort: Bool) {
        self.path = path
        self.shouldSort = shouldSort
    }
    
    public func run() {
        let result = compile()  
        var funcResults = result.funcResults
        
        if shouldSort {
            funcResults.sort(by: { $0.compileTime > $1.compileTime })
        }
        
        print("\n============== \(path.lastComponent) ==============")
        funcResults.forEach { print($0.colorfulDescription) }
        
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

