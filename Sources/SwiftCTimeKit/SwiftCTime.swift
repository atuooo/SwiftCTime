import PathKit
import Foundation

public struct SwiftCTime {
    let executePath: Path
    let shouldSort: Bool
    let shouldShowDetail: Bool
    
    public init(executePath: String, shouldSort: Bool, shouldShowDetail: Bool) {
        self.executePath = Path(executePath)
        self.shouldSort = shouldSort
        self.shouldShowDetail = shouldShowDetail
    }
    
    public func runAndPrint() {
        findAllSwiftFilePaths(at: executePath)
        .map{ SwiftFile(path: $0, shouldSort: shouldSort) }
        .forEach { $0.run() }
    }
}

// MARK: - Helper Methods
extension SwiftCTime {
    fileprivate func findAllSwiftFilePaths(at path: Path) -> [Path] {
        if path.isFile {
            if path.extension == "swift" {
                return [path]
            } else {
                return [] // no swift file
            }
        } else {
            return path.glob("*.swift")
        }
    }
}
