import Foundation
import PathKit
import SwiftCTimeKit
import CommandLineKit

let appVersion = "0.1.0"

let cli = CommandLineKit.CommandLine()
cli.formatOutput = { s, type in
    var str: String
    switch(type) {
    case .error: str = s.red.bold
    case .optionFlag: str = s.green.underline
    default: str = s
    }
    
    return cli.defaultFormat(s: str, type: type)
}

let filePathOption = StringOption(
    shortFlag: "p", longFlag: "path",
    helpMessage: "Path of file or directory you want to compile. Default is current folder.")
cli.addOption(filePathOption)

let shouldSortOption = BoolOption(shortFlag: "s", longFlag: "sort", helpMessage: "Sort fuction by compile time in descending order.")
cli.addOption(shouldSortOption)

let versionOption = BoolOption(shortFlag: "v", longFlag: "version", helpMessage: "Print version.")
cli.addOption(versionOption)

let helpOption = BoolOption(shortFlag: "h", longFlag: "help",
                            helpMessage: "Print this help message.")
cli.addOption(helpOption)

do {
    try cli.parse()
} catch {
    print(error)
    cli.printUsage(error)
    exit(EX_USAGE)
}

if helpOption.value {
    cli.printUsage()
    exit(EX_OK)
}

if versionOption.value {
    print("swiftctime: \(appVersion)".green)
    exit(EX_OK);
}

var filePath = filePathOption.value ?? "."

if !cli.unparsedArguments.isEmpty {
    func printUnknow() {
        print("Unknow arguments: \(cli.unparsedArguments)".red)
        cli.printUsage()
        exit(EX_USAGE)
    }
    
    if cli.unparsedArguments.count == 1 {
        let arg = cli.unparsedArguments[0]

        if Path(arg).isReadable {
            filePath = arg
        } else {
            printUnknow()
        }
    } else {
        printUnknow()
    }
}

let shouldSort = shouldSortOption.value

let swiftcTime = SwiftCTime(executePath: filePath, shouldSort: shouldSort, shouldShowDetail: false)
swiftcTime.runAndPrint()


