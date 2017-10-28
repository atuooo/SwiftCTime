//
//  SwiftCompileProcess.swift
//  SwiftCTimePackageDescription
//
//  Created by ooatuoo on 2017/10/15.
//

import Foundation
import PathKit

struct SwiftCompileProcess {
    let process: Process
    
    init(path: Path) {
        process = Process()
        process.launchPath = "/usr/bin/swift"
        process.currentDirectoryPath = path.parent().absolute().string
        process.arguments = ["-Xfrontend", "-debug-time-function-bodies", path.lastComponent]
    }
    
    func execute() -> String {
        let pipe = Pipe()
        process.standardError = pipe

        let fileHandler = pipe.fileHandleForReading
        process.launch()
        
        let data = fileHandler.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            return output
        } else {
            return "no result"
        }
    }
    
    static func compileFile(at path: Path) -> String {
        let process = Process()
        process.launchPath = "/usr/bin/swift"
        process.currentDirectoryPath = path.parent().absolute().string
        process.arguments = ["-continue-building-after-errors", "-Xfrontend", "-debug-time-function-bodies", path.lastComponent]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        let fileHandler = pipe.fileHandleForReading
        process.launch()
        
        let data = fileHandler.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            return output
        } else {
            return "no result"
        }
    }
}
