import Foundation

extension StringTransform {
    public static let toLatinASCII = StringTransform("Latin-ASCII")
}

extension String {
    @discardableResult
    public mutating func applyTransform(_ transform: StringTransform, reverse: Bool = false) -> Bool {
        guard #available(macOS 10.11, *),
            let transformed = applyingTransform(transform, reverse: reverse)
        else { return false }

        self = transformed
        return true
    }

    public func hasPrefix(_ prefix: String, options: CompareOptions) -> Bool {
        return range(of: prefix, options: options.union(.anchored)) != nil
    }

    public mutating func makeRelativePath() {
        let cwd = FileManager.default.currentDirectoryPath

        guard var range = range(of: cwd, options: .anchored) else {
            return
        }

        if range.upperBound < endIndex, self[range.upperBound] == "/" {
            range = range.lowerBound ..< index(after: range.upperBound)
        }

        removeSubrange(range)
    }
}
