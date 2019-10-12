import Foundation

struct NilError: Error, CustomNSError {
    static let lineNumberKey = "line-number"

    let file: StaticString
    let line: UInt

    var errorDescription: String? {
        return "Unexpectedly found nil while unwrapping optional"
    }

    var errorUserInfo: [String: Any] {
        return [
            NSFilePathErrorKey: file,
            NSLocalizedDescriptionKey: errorDescription!,
            NilError.lineNumberKey: line,
        ]
    }
}
